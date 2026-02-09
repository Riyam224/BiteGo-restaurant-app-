import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/api_error_handler.dart';
import 'package:restaurant_app/core/networking/dio_client.dart';

/// Public API Service - Base class for unauthenticated endpoints
///
/// Use this for endpoints that DO NOT require authentication:
/// - Registration
/// - Login
/// - Forgot Password
/// - Verify OTP
/// - Reset Password
///
/// SOLID Principles Applied:
/// - Single Responsibility: Handles HTTP requests for public endpoints only
/// - Open/Closed: Open for extension (child services), closed for modification
/// - Dependency Inversion: Depends on Dio abstraction, not concrete implementation
///
/// Clean Architecture:
/// - Lives in the Data Layer
/// - Communicates with external APIs
/// - Returns raw data (not domain entities)
/// - NO authentication headers are added to requests
abstract class PublicApiService {
  late final Dio _dio;

  PublicApiService() {
    _dio = DioClient.createPublicDio();
  }

  /// Getter for accessing Dio instance in child classes if needed
  Dio get dio => _dio;

  // =========================
  // GET REQUEST
  // =========================

  /// Performs a GET request (public endpoint)
  ///
  /// [endpoint] - API endpoint (e.g., '/auth/verify-email')
  /// [queryParameters] - Optional query params (e.g., {'token': 'abc123'})
  /// [headers] - Optional custom headers
  ///
  /// Returns Response on success, throws String error message on failure
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  // =========================
  // POST REQUEST
  // =========================

  /// Performs a POST request (public endpoint)
  ///
  /// [endpoint] - API endpoint
  /// [data] - Request body data
  /// [queryParameters] - Optional query params
  /// [headers] - Optional custom headers
  ///
  /// Returns Response on success, throws String error message on failure
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  // =========================
  // PUT REQUEST
  // =========================

  /// Performs a PUT request (full update) - public endpoint
  ///
  /// [endpoint] - API endpoint
  /// [data] - Request body data
  /// [queryParameters] - Optional query params
  /// [headers] - Optional custom headers
  ///
  /// Returns Response on success, throws String error message on failure
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  // =========================
  // PATCH REQUEST
  // =========================

  /// Performs a PATCH request (partial update) - public endpoint
  ///
  /// [endpoint] - API endpoint
  /// [data] - Request body data
  /// [queryParameters] - Optional query params
  /// [headers] - Optional custom headers
  ///
  /// Returns Response on success, throws String error message on failure
  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  // =========================
  // DELETE REQUEST
  // =========================

  /// Performs a DELETE request - public endpoint
  ///
  /// [endpoint] - API endpoint
  /// [data] - Optional request body
  /// [queryParameters] - Optional query params
  /// [headers] - Optional custom headers
  ///
  /// Returns Response on success, throws String error message on failure
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }
}
