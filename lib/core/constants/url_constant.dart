class UrlConstant {
  static const String azureUrl =
      'https://pcvk-containerapp.lemonisland-43c085da.southeastasia.azurecontainerapps.io/api/';

  static Uri buildAzureEndpoint(
    String endpoint, {
    Map<String, String?>? queryParameters,
  }) => Uri.https(azureUrl, endpoint, queryParameters);
}
