import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/constants/url_constant.dart';
import 'package:jawara/core/models/BlobStorage/storage_response.dart';
import 'package:jawara/core/models/BlobStorage/user_images_response.dart';

class AzureBlobStorageService {
  static const String _uploadPublicEndpoint = 'storage/public/upload';
  static const String _getPublicImagesEndpoint = 'storage/public/get-images';
  static const String _deletePublicEndpoint = 'storage/public/delete';

  static const String _uploadPrivateEndpoint = 'storage/private/upload';
  static const String _getPrivateImagesEndpoint = 'storage/private/get-images';
  static const String _deletePrivateEndpoint = 'storage/private/delete';

  Future<String?> _getFirebaseToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (kDebugMode) {
          print('⚠️ User not logged in to Firebase Auth');
        }
        return null;
      }

      final token = await user.getIdToken();
      if (kDebugMode) {
        print('✅ Firebase ID token obtained');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting Firebase token: $e');
      }
      return null;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = await _getFirebaseToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<StorageResponse?> uploadImage({
    required File file,
    bool isPrivate = false,
    String? prefixName,
    String? customFileName,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        UrlConstant.buildAzureEndpoint(
          isPrivate ? _uploadPrivateEndpoint : _uploadPublicEndpoint,
          queryParameters: {
            'prefix_name': prefixName,
            'custom_name': customFileName,
          },
        ),
      );

      final headers = await _getHeaders();
      request.headers.addAll(headers);

      if (kDebugMode) {
        print('Request headers: $headers');
        print('Request URL: ${request.url}');
        print('Request method: ${request.method}');
      }

      final extension = file.path.toLowerCase().split('.').last;
      http.MediaType? contentType;

      switch (extension) {
        case 'png':
          contentType = http.MediaType('image', 'png');
          break;
        case 'gif':
          contentType = http.MediaType('image', 'gif');
          break;
        case 'webp':
          contentType = http.MediaType('image', 'webp');
          break;
        default:
          contentType = http.MediaType('image', 'jpeg');
      }

      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: contentType,
        filename: customFileName,
      );

      request.files.add(multipartFile);

      if (kDebugMode) {
        print('Multipart file details:');
        print('  Field name: ${multipartFile.field}');
        print('  Filename: ${multipartFile.filename}');
        print('  Content-Type: ${multipartFile.contentType}');
        print('  Length: ${multipartFile.length}');
        print('Total files in request: ${request.files.length}');
        print('Sending request...');
      }

      var response = await http.Response.fromStream(await request.send());

      if (kDebugMode) {
        print('Response received!');
        print('Response status code: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body length: ${response.body.length}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          final StorageResponse storageResponse = StorageResponse.fromJson(
            data,
          );

          if (kDebugMode) {
            print('✅ Upload successful!');
            print('URL: ${storageResponse.blobUrl}');
          }

          return storageResponse;
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error parsing response: $e');
            print('Response body: ${response.body}');
          }
          rethrow;
        }
      } else {
        if (kDebugMode) {
          print('❌ Upload failed: ${response.statusCode}');
          print('Response: ${response.body}');
        }
        throw Exception('Upload failed: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading file: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteFile({
    required String blobName,
    bool isPrivate = false,
  }) async {
    try {
      if (kDebugMode) {
        print('🗑️ Deleting file...');
        print('Blob Name: $blobName');
      }

      final response = await http.delete(
        UrlConstant.buildAzureEndpoint(
          '${isPrivate ? _deletePrivateEndpoint : _deletePublicEndpoint}/$blobName',
        ),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ Delete successful!');
        }
      } else {
        if (kDebugMode) {
          print('❌ Delete failed: ${response.statusCode}');
        }
        throw Exception('Delete failed: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting file: $e');
      }
      rethrow;
    }
  }

  Future<UserImagesResponse?> getImages({
    String? uid,
    String? filenamePrefix,
    bool isPrivate = false,
  }) async {
    try {
      final response = await http.get(
        UrlConstant.buildAzureEndpoint(
          isPrivate ? _getPrivateImagesEndpoint : _getPublicImagesEndpoint,
          queryParameters: {'uid': uid, 'filenamePrefix': filenamePrefix},
        ),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserImagesResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting images: $e');
      }
      return null;
    }
  }
}
