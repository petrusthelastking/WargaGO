/// Mock responses for OCR service tests
class OcrMockResponses {
  static final Map<String, dynamic> healthSuccess = {
    "status": "healthy",
    "model_loaded": true,
    "detection_model": "PP-OCRv5_mobile_det",
    "recognition_model": "PP-OCRv5_mobile_rec",
  };

  static final Map<String, dynamic> healthUnhealthy = {
    "status": "unhealthy",
    "model_loaded": false,
    "detection_model": "",
    "recognition_model": "",
  };

  static final Map<String, dynamic> recognizeSuccess = {
    "filename": "maxresdefault.jpg",
    "results": [
      {
        "text": "Khasiat",
        "confidence": 0.905269205570221,
        "bbox": [
          [33, 2],
          [375, 12],
          [371, 154],
          [29, 143],
        ],
      },
      {
        "text": "LOBAK",
        "confidence": 0.9955479502677917,
        "bbox": [
          [47, 162],
          [341, 159],
          [342, 271],
          [48, 273],
        ],
      },
      {
        "text": "PUTIH",
        "confidence": 0.9955593347549438,
        "bbox": [
          [45, 298],
          [308, 298],
          [308, 409],
          [45, 409],
        ],
      },
    ],
    "processing_time_ms": 707.5338363647461,
    "num_detections": 3,
  };

  static final Map<String, dynamic> recognizeEmpty = {
    "filename": "empty.jpg",
    "results": [],
    "processing_time_ms": 50.0,
    "num_detections": 0,
  };

  static final Map<String, dynamic> recognizeSingle = {
    "filename": "single.jpg",
    "results": [
      {
        "text": "Test",
        "confidence": 0.99,
        "bbox": [
          [0, 0],
          [100, 0],
          [100, 50],
          [0, 50],
        ],
      },
    ],
    "processing_time_ms": 100.5,
    "num_detections": 1,
  };

  static final Map<String, dynamic> recognizeMultipleConfidence = {
    "filename": "confidence_test.jpg",
    "results": [
      {
        "text": "High",
        "confidence": 0.99,
        "bbox": [
          [0, 0],
          [50, 0],
          [50, 20],
          [0, 20],
        ],
      },
      {
        "text": "Medium",
        "confidence": 0.75,
        "bbox": [
          [0, 30],
          [50, 30],
          [50, 50],
          [0, 50],
        ],
      },
      {
        "text": "Low",
        "confidence": 0.50,
        "bbox": [
          [0, 60],
          [50, 60],
          [50, 80],
          [0, 80],
        ],
      },
    ],
    "processing_time_ms": 200.0,
    "num_detections": 3,
  };
}
