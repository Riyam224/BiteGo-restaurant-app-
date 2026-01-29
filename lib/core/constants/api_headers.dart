class ApiHeaders {
  ApiHeaders._();

  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';

  static const String applicationJson = 'application/json';

  /// Bearer token helper
  static Map<String, String> bearer(String accessToken) => {
    authorization: 'Bearer $accessToken',
    contentType: applicationJson,
  };
}
