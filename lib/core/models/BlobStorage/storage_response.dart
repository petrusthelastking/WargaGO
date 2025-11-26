class StorageResponse {
  final bool success;
  final String blobName;
  final String blobUrl;
  final String? message;

  StorageResponse({
    required this.success,
    required this.blobName,
    required this.blobUrl,
    this.message,
  });

  factory StorageResponse.fromJson(Map<String, dynamic> json) {
    return StorageResponse(
      success: json['success'] as bool,
      blobName: json['blob_name'] as String,
      blobUrl: json['blob_url'] as String,
      message: json['message'] == null ? null : json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'blob_name': blobName,
      'blob_url': blobUrl,
      'message': message,
    };
  }
}
