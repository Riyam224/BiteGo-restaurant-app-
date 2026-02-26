import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/core/config/network_config.dart';
import 'package:restaurant_app/core/config/timing_config.dart';
import 'package:restaurant_app/core/constants/api_base.dart';
import 'package:restaurant_app/core/storage/secure_storage_service.dart';

/// Factory class that creates and configures Dio HTTP client instances.
/// Provides separate clients for public and protected endpoints.
///
/// Following SOLID Principles:
/// - Single Responsibility: Only creates and configures HTTP client
/// - Open/Closed: Easy to extend with new interceptors without modifying existing code
class DioClient {
  /// Creates a Dio client for PUBLIC endpoints (no authentication required)
  /// Use for: register, login, forgot-password, verify-otp, reset-password
  static Dio createPublicDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBase.apiV1,
        connectTimeout: TimingConfig.connectionTimeout,
        receiveTimeout: TimingConfig.receiveTimeout,
        headers: {
          NetworkConfig.acceptHeader: NetworkConfig.acceptValue,
        },
      ),
    );

    // Basic request/response logging (NO AUTH INTERCEPTOR)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint('🌐 [PublicDio] Request → ${options.method} ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
                '✅ [PublicDio] Response → ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
                '❌ [PublicDio] Error → ${error.response?.statusCode} ${error.requestOptions.uri}');
            debugPrint('❌ [PublicDio] Message → ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );

    _addDebugLogging(dio);
    return dio;
  }

  /// Creates a Dio client for PROTECTED endpoints (authentication required)
  /// Use for: profile, cart, orders, addresses, reviews, etc.
  static Dio createProtectedDio(SecureStorageService storageService) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBase.apiV1,
        connectTimeout: TimingConfig.connectionTimeout,
        receiveTimeout: TimingConfig.receiveTimeout,
        headers: {
          NetworkConfig.acceptHeader: NetworkConfig.acceptValue,
        },
      ),
    );

    // JWT Token Injection Interceptor
    // Automatically adds Bearer token to all authenticated requests
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get JWT token from secure storage
          final token = await storageService.getAccessToken();

          // Add Bearer token to Authorization header if available
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            debugPrint('🌐 [ProtectedDio] Request → ${options.method} ${options.uri}');
            if (token != null) {
              debugPrint('🔐 [ProtectedDio] Auth Token → ${token.substring(0, 20)}...');
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
                '✅ [ProtectedDio] Response → ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
                '❌ [ProtectedDio] Error → ${error.response?.statusCode} ${error.requestOptions.uri}');
            debugPrint('❌ [ProtectedDio] Message → ${error.message}');
          }

          return handler.next(error);
        },
      ),
    );

    _addDebugLogging(dio);
    return dio;
  }

  /// Adds detailed debug logging in development mode only
  static void _addDebugLogging(Dio dio) {
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('🔹 $obj'),
        ),
      );
    }
  }

  /// Legacy method for backward compatibility - requires storage service
  /// @deprecated Use createProtectedDio(storageService) instead
  @Deprecated('Use createProtectedDio(storageService) for authenticated endpoints')
  static Dio createDio() {
    throw UnimplementedError(
      'createDio() is deprecated. Use createProtectedDio(storageService) instead',
    );
  }
}
