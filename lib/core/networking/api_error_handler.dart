import 'package:dio/dio.dart';
import 'package:restaurant_app/core/error/auth_error_msg.dart';
import 'package:restaurant_app/core/utils/app_logger.dart';

class ApiErrorHandler {
  /// Converts Dio errors or  generic exceptions into readable messages
  static String handleError(dynamic error) {
    if (error is DioException) {
      // Log the error with full details
      AppLogger.apiError(
        error.requestOptions.uri.toString(),
        error,
        stackTrace: error.stackTrace,
      );

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          AppLogger.error('⏱️ Network Timeout: ${error.message}');
          return ErrorMessages.timeout;

        case DioExceptionType.connectionError:
          AppLogger.error('🌐 Connection Error: No Internet or server unreachable');
          return ErrorMessages.noInternet;

        case DioExceptionType.cancel:
          AppLogger.warning('Request cancelled by user');
          return 'Request cancelled by user';

        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);

        default:
          AppLogger.error('Unexpected error: ${error.message}');
          return ErrorMessages.unexpectedError;
      }
    } else {
      // Log generic errors
      AppLogger.error('Non-DioException error occurred', error: error);
      return ErrorMessages.getErrorMessage(error);
    }
  }

  /// Handles API response-level errors (400s / 500s)
  static String _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    // Log the error response
    AppLogger.error(
      '❌ HTTP $statusCode Error',
      error: {
        'url': response?.requestOptions.uri.toString(),
        'method': response?.requestOptions.method,
        'statusCode': statusCode,
        'responseData': data,
      },
    );

    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        final message = data['message'].toString();
        AppLogger.error('Server message: $message');
        return message;
      }

      if (data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'];

        if (errors.containsKey('email')) {
          final emailErrors = errors['email'];
          if (emailErrors is List && emailErrors.isNotEmpty) {
            final errorMsg = emailErrors.first.toString();
            AppLogger.error('Email validation error: $errorMsg');
            return errorMsg;
          }
        }

        if (errors.containsKey('generalErrors')) {
          final general = errors['generalErrors'];
          if (general is List && general.isNotEmpty) {
            final errorMsg = general.first.toString();
            AppLogger.error('General error: $errorMsg');
            return errorMsg;
          }
        }
      }
    }

    String errorMessage;
    switch (statusCode) {
      case 400:
        errorMessage = ErrorMessages.badRequest;
        break;
      case 401:
        errorMessage = ErrorMessages.unauthorized;
        break;
      case 403:
        errorMessage = ErrorMessages.forbidden;
        break;
      case 404:
        errorMessage = ErrorMessages.notFound;
        break;
      case 409:
        errorMessage = ErrorMessages.emailAlreadyExists;
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        errorMessage = ErrorMessages.serverError;
        break;
      default:
        errorMessage = ErrorMessages.unexpectedError;
    }

    AppLogger.error('Mapped to: $errorMessage');
    return errorMessage;
  }
}
