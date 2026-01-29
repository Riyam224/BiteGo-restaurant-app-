import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/core/config/network_config.dart';
import 'package:restaurant_app/core/config/timing_config.dart';
import 'package:restaurant_app/core/constants/api_base.dart';

/// Factory class that creates and configures Dio HTTP client instances.
/// Sets up interceptors for API key injection, logging, and error handling.
class DioClient {
  static Dio createDio() {
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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (kDebugMode) {
            debugPrint('🌐 [DioClient] Request → ${options.method} ${options.uri}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
                '✅ [DioClient] Response → ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
                '❌ [DioClient] Error → ${error.response?.statusCode} ${error.requestOptions.uri}');
            debugPrint('❌ [DioClient] Message → ${error.message}');
          }

          return handler.next(error);
        },
      ),
    );

    /// Debug-only detailed logging to avoid performance overhead in production
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

    return dio;
  }
}
