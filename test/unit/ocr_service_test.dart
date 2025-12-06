import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wargago/core/models/OCR/health_response.dart';
import 'package:wargago/core/models/OCR/ocr_response.dart';
import 'package:wargago/core/services/ocr_service.dart';

import 'ocr_service_test.mocks.dart';
import '../fixtures/ocr_mock_responses.dart';

@GenerateMocks([http.Client])
void main() async {
  await dotenv.load(fileName: ".env");
  group('OCRService Unit Tests', () {
    late MockClient mockClient;
    late OCRService ocrService;

    setUp(() {
      mockClient = MockClient();
      ocrService = OCRService(httpClient: mockClient);
    });

    tearDown(() {
      mockClient.close();
    });

    group('getHealth', () {
      test('should return OcrHealthResponse when status code is 200', () async {
        if (kDebugMode) {
          print('📝 Testing: Get health response successfully');
        }
        // Arrange
        when(mockClient.get(any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(OcrMockResponses.healthSuccess), 200),
        );

        // Act
        final result = await ocrService.getHealth();

        // Assert
        expect(result, isA<OcrHealthResponse>());
        expect(result.status, equals('healthy'));
        expect(result.modelLoaded, isTrue);
        expect(result.detectionModel, equals('PP-OCRv5_mobile_det'));
        expect(result.recognitionModel, equals('PP-OCRv5_mobile_rec'));
        verify(mockClient.get(any)).called(1);
        if (kDebugMode) {
          print('✅ Passed: Health response retrieved\n');
        }
      });

      test('should throw exception when status code is not 200', () async {
        if (kDebugMode) {
          print('📝 Testing: Get health with 500 error');
        }
        // Arrange
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        // Act & Assert
        expect(
          () => ocrService.getHealth(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch health - 500'),
            ),
          ),
        );
        verify(mockClient.get(any)).called(1);
        if (kDebugMode) {
          print('✅ Passed: Exception thrown correctly\n');
        }
      });

      test('should throw exception when status code is 404', () async {
        if (kDebugMode) {
          print('📝 Testing: Get health with 404 error');
        }
        // Arrange
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        expect(
          () => ocrService.getHealth(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch health - 404'),
            ),
          ),
        );
        if (kDebugMode) {
          print('✅ Passed: Exception thrown correctly\n');
        }
      });

      test('should parse response with model_loaded as false', () async {
        if (kDebugMode) {
          print('📝 Testing: Get health with unhealthy status');
        }
        // Arrange
        when(mockClient.get(any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(OcrMockResponses.healthUnhealthy), 200),
        );

        // Act
        final result = await ocrService.getHealth();

        // Assert
        expect(result.status, equals('unhealthy'));
        expect(result.modelLoaded, isFalse);
        if (kDebugMode) {
          print('✅ Passed: Unhealthy status parsed correctly\n');
        }
      });
    });

    group('recognizeText', () {
      test('should return OcrResponse when status code is 200', () async {
        if (kDebugMode) {
          print('📝 Testing: Recognize text from image successfully');
        }
        // Arrange
        final mockFile = File('test/fixtures/test_images/test_ocr_image.jpg');
        final mockStreamedResponse = http.StreamedResponse(
          Stream.value(
            utf8.encode(json.encode(OcrMockResponses.recognizeSuccess)),
          ),
          200,
        );

        when(
          mockClient.send(any),
        ).thenAnswer((_) async => mockStreamedResponse);

        // Act
        final result = await ocrService.recognizeText(mockFile);

        // Assert
        expect(result, isA<OcrResponse>());
        expect(result.filename, equals('maxresdefault.jpg'));
        expect(result.results, hasLength(3));
        expect(result.results[0].text, equals('Khasiat'));
        expect(result.results[0].confidence, closeTo(0.905, 0.001));
        expect(result.results[1].text, equals('LOBAK'));
        expect(result.results[2].text, equals('PUTIH'));
        expect(result.processingTimeMs, closeTo(707.53, 0.01));
        expect(result.numDetections, equals(3));
        verify(mockClient.send(any)).called(1);
        if (kDebugMode) {
          print('✅ Passed: Text recognition successful\n');
        }
      });

      test('should throw exception when status code is not 200', () async {
        if (kDebugMode) {
          print('📝 Testing: Recognize text with 500 error');
        }
        // Arrange
        final mockFile = File('test/fixtures/test_images/test_ocr_image.jpg');
        final mockStreamedResponse = http.StreamedResponse(
          Stream.value(utf8.encode('Internal Server Error')),
          500,
        );

        when(
          mockClient.send(any),
        ).thenAnswer((_) async => mockStreamedResponse);

        // Act & Assert
        expect(
          () => ocrService.recognizeText(mockFile),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to predict - 500'),
            ),
          ),
        );
        if (kDebugMode) {
          print('✅ Passed: Exception thrown correctly\n');
        }
      });

      test('should handle empty results array', () async {
        if (kDebugMode) {
          print('📝 Testing: Recognize text with empty results');
        }
        // Arrange
        final mockFile = File('test/fixtures/test_images/1.jpg');
        final mockStreamedResponse = http.StreamedResponse(
          Stream.value(
            utf8.encode(json.encode(OcrMockResponses.recognizeEmpty)),
          ),
          200,
        );

        when(
          mockClient.send(any),
        ).thenAnswer((_) async => mockStreamedResponse);

        // Act
        final result = await ocrService.recognizeText(mockFile);

        // Assert
        expect(result.filename, equals('empty.jpg'));
        expect(result.results, isEmpty);
        expect(result.numDetections, equals(0));
        if (kDebugMode) {
          print('✅ Passed: Empty results handled correctly\n');
        }
      });

      test('should throw exception when status code is 400', () async {
        if (kDebugMode) {
          print('📝 Testing: Recognize text with 400 error');
        }
        // Arrange
        final mockFile = File('test/fixtures/test_images/1.jpg');
        final mockStreamedResponse = http.StreamedResponse(
          Stream.value(utf8.encode('Bad Request')),
          400,
        );

        when(
          mockClient.send(any),
        ).thenAnswer((_) async => mockStreamedResponse);

        // Act & Assert
        expect(
          () => ocrService.recognizeText(mockFile),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to predict - 400'),
            ),
          ),
        );
        if (kDebugMode) {
          print('✅ Passed: Exception thrown correctly\n');
        }
      });
    });

    group('Constructor', () {
      test('should use default http.Client when not provided', () {
        if (kDebugMode) {
          print('📝 Testing: Constructor with default http.Client');
        }
        // Act
        final service = OCRService();

        // Assert
        expect(service, isA<OCRService>());
        if (kDebugMode) {
          print('✅ Passed: Default client created\n');
        }
      });

      test('should use provided http.Client', () {
        if (kDebugMode) {
          print('📝 Testing: Constructor with custom http.Client');
        }
        // Arrange
        final customClient = MockClient();

        // Act
        final service = OCRService(httpClient: customClient);

        // Assert
        expect(service, isA<OCRService>());
        if (kDebugMode) {
          print('✅ Passed: Custom client used\n');
        }
      });
    });
  });
}
