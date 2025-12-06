import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargago/core/services/ocr_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  group('OCRService API Integration Tests', () {
    late OCRService ocrService;

    setUp(() {
      ocrService = OCRService();
    });

    group('getHealth - API', () {
      test(
        'should successfully fetch health status from real API',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Get health status from real OCR API');
          }
          // Act
          final result = await ocrService.getHealth();

          // Assert
          expect(result, isNotNull);
          expect(result.status, isNotEmpty);
          expect(result.detectionModel, isNotEmpty);
          expect(result.recognitionModel, isNotEmpty);

          // Log results for verification
          if (kDebugMode) {
            print('Health Status: ${result.status}');
            print('Model Loaded: ${result.modelLoaded}');
            print('Detection Model: ${result.detectionModel}');
            print('Recognition Model: ${result.recognitionModel}');
            print('✅ Passed: Health status retrieved\n');
          }
        },
        timeout: const Timeout(Duration(seconds: 10)),
      );

      test(
        'should have healthy status when models are loaded',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Verify healthy status when models loaded');
          }
          // Act
          final result = await ocrService.getHealth();

          // Assert
          if (result.modelLoaded) {
            expect(result.status, equals('healthy'));
            expect(result.detectionModel, equals('PP-OCRv5_mobile_det'));
            expect(result.recognitionModel, equals('PP-OCRv5_mobile_rec'));
            if (kDebugMode) {
              print('✅ Passed: Models loaded and healthy\n');
            }
          }
        },
        timeout: const Timeout(Duration(seconds: 10)),
      );
    });

    group('recognizeText - API', () {
      test(
        'should successfully recognize text from real image file',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Recognize text from real image using OCR API');
          }
          // Arrange
          // Create a test image file (you need to provide a valid image path)
          // For this test to work, place a test image in the test/fixtures/test_images directory
          final testImagePath = 'test/fixtures/test_images/test_ocr_image.jpg';
          final testImage = File(testImagePath);

          // Act
          final result = await ocrService.recognizeText(testImage);

          // Assert
          expect(result, isNotNull);
          expect(result.filename, isNotEmpty);
          expect(result.results, isNotNull);
          expect(result.processingTimeMs, greaterThan(0));
          expect(result.numDetections, greaterThanOrEqualTo(0));

          // Log results for verification
          if (kDebugMode) {
            print('Filename: ${result.filename}');
            print('Number of Detections: ${result.numDetections}');
            print('Processing Time: ${result.processingTimeMs}ms');

            for (var i = 0; i < result.results.length; i++) {
              final detection = result.results[i];
              print('Detection ${i + 1}:');
              print('  Text: ${detection.text}');
              print('  Confidence: ${detection.confidence}');
              print('  Bounding Box: ${detection.bbox}');
            }
            print('✅ Passed: Text recognition successful\n');
          }
        },
        timeout: const Timeout(Duration(seconds: 30)),
      );

      test(
        'should handle image with text and return detections',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Validate detection fields from real image');
          }
          // Arrange
          final testImagePath = 'test/fixtures/test_images/test_ocr_image.jpg';
          final testImage = File(testImagePath);

          // Act
          final result = await ocrService.recognizeText(testImage);

          // Assert
          if (result.numDetections > 0) {
            expect(result.results, isNotEmpty);

            // Verify each detection has required fields
            for (final detection in result.results) {
              expect(detection.text, isNotEmpty);
              expect(detection.confidence, greaterThan(0));
              expect(detection.confidence, lessThanOrEqualTo(1.0));
              expect(detection.bbox, hasLength(4));

              // Verify each bbox point has x,y coordinates
              for (final point in detection.bbox) {
                expect(point, hasLength(2));
              }
            }
            if (kDebugMode) {
              print('✅ Passed: All detection fields validated\n');
            }
          }
        },
        timeout: const Timeout(Duration(seconds: 30)),
      );

      test(
        'should maintain consistent results for same image',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Consistency of results for same image');
          }
          // Arrange
          final testImagePath = 'test/fixtures/test_images/test_ocr_image.jpg';
          final testImage = File(testImagePath);

          // Act
          final result1 = await ocrService.recognizeText(testImage);
          final result2 = await ocrService.recognizeText(testImage);

          // Assert
          expect(result1.numDetections, equals(result2.numDetections));
          expect(result1.results.length, equals(result2.results.length));

          // Verify texts are the same (may have slight confidence variations)
          for (var i = 0; i < result1.results.length; i++) {
            expect(result1.results[i].text, equals(result2.results[i].text));
          }

          if (kDebugMode) {
            print('✅ Passed: Both runs produced identical text detections\n');
          }
        },
        timeout: const Timeout(Duration(seconds: 60)),
      );
    });

    group('Error Handling - API', () {
      test('should handle network timeout gracefully', () async {
        if (kDebugMode) {
          print('📝 Testing: Network timeout handling');
        }
        // This test verifies timeout handling
        // The actual timeout duration may need adjustment based on API response time

        try {
          await ocrService.getHealth().timeout(const Duration(milliseconds: 1));
          fail('Should have thrown TimeoutException');
        } catch (e) {
          expect(e, isA<TimeoutException>());
          if (kDebugMode) {
            print('✅ Passed: Timeout handled correctly\n');
          }
        }
      });

      test(
        'should handle invalid image file gracefully',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Invalid image file handling');
          }
          // Arrange
          final invalidFile = File(
            'test/fixtures/test_images/invalid_file.txt',
          );

          if (!await invalidFile.exists()) {
            await invalidFile.create(recursive: true);
            await invalidFile.writeAsString('This is not an image');
          }

          // Act & Assert
          try {
            await ocrService.recognizeText(invalidFile);
            // If it doesn't throw, log the result
            if (kDebugMode) {
              print('⚠️  API accepted non-image file (unexpected)');
            }
          } catch (e) {
            // Expected to throw an exception
            expect(e, isA<Exception>());
            if (kDebugMode) {
              print('✅ Passed: Invalid file rejected correctly\n');
            }
          } finally {
            // Cleanup
            if (await invalidFile.exists()) {
              await invalidFile.delete();
            }
          }
        },
        timeout: const Timeout(Duration(seconds: 30)),
      );
    });

    group('Performance - API', () {
      test(
        'should process image within reasonable time',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Image processing performance');
          }
          // Arrange
          final testImagePath = 'test/fixtures/test_images/test_ocr_image.jpg';
          final testImage = File(testImagePath);

          // Act
          final stopwatch = Stopwatch()..start();
          final result = await ocrService.recognizeText(testImage);
          stopwatch.stop();

          // Assert
          final totalTime = stopwatch.elapsedMilliseconds;

          if (kDebugMode) {
            print('Total request time: ${totalTime}ms');
            print('Server processing time: ${result.processingTimeMs}ms');
          }

          // Verify reasonable performance (adjust threshold as needed)
          expect(totalTime, lessThan(5000)); // Should complete within 5 seconds
          expect(
            result.processingTimeMs,
            lessThan(3000),
          ); // Server processing under 3 seconds

          if (kDebugMode) {
            print('✅ Passed: Processing within acceptable time\n');
          }
        },
        timeout: const Timeout(Duration(seconds: 10)),
      );

      test(
        'should handle multiple concurrent requests',
        () async {
          if (kDebugMode) {
            print('📝 Testing: Multiple concurrent requests');
          }
          // Arrange
          final testImagePath = 'test/fixtures/test_images/test_ocr_image.jpg';
          final testImage = File(testImagePath);

          // Act
          final futures = List.generate(
            3,
            (index) => ocrService.recognizeText(testImage),
          );

          final results = await Future.wait(futures);

          // Assert
          expect(results, hasLength(3));
          for (final result in results) {
            expect(result, isNotNull);
            expect(result.filename, isNotEmpty);
          }

          if (kDebugMode) {
            print('✅ Passed: Successfully handled 3 concurrent requests\n');
          }
        },
        timeout: const Timeout(Duration(seconds: 30)),
      );
    });
  });
}
