import 'package:restaurant_app/core/constants/api_headers.dart';

class NetworkConfig {
  const NetworkConfig._();

  static const String acceptHeader = 'Accept';
  static const String acceptValue = ApiHeaders.applicationJson;
  static const String contentTypeHeader = ApiHeaders.contentType;
  static const String contentTypeValue = ApiHeaders.applicationJson;

  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusTooManyRequests = 429;
  static const int statusInternalServerError = 500;
  static const int statusServiceUnavailable = 503;
}
