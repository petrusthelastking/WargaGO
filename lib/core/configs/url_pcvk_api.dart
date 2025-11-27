import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlPCVKAPI {
  // Use getter to safely access dotenv (handles missing .env in production)
  static String get azureUrl => dotenv.maybeGet('PCVK_API_URL') ?? '';

  // Helper to safely get boolean from dotenv
  static bool get isSSL => (dotenv.maybeGet('PCVK_API_HTTPS') ?? 'true') == 'true';

  static Uri buildAzureEndpoint(
    String endpoint, {
    Map<String, String?>? queryParameters,
  }) {
    Map<String, String>? cleanParams;
    if (queryParameters != null) {
      cleanParams = {};
      queryParameters.forEach((key, value) {
        if (value != null) {
          cleanParams![key] = value;
        }
      });
    }


    return isSSL
        ? Uri.https(azureUrl, 'api/$endpoint', cleanParams)
        : Uri.http(azureUrl, 'api/$endpoint', cleanParams);
  }
}
