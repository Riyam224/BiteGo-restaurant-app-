class ApiBase {
  ApiBase._();

  /// Change this only per environment (dev / prod)
  static const String host = 'https://web-production-e1bea.up.railway.app';

  /// API root
  static const String apiV1 = '$host/api/v1';

  /// Docs (optional)
  static const String swagger = '$host/api/docs/';
  static const String schema = '$host/api/schema/';
}
