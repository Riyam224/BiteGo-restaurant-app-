import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/api_error_handler.dart';
import 'package:restaurant_app/core/networking/dio_client.dart';

/// Protected API Service - Base class for authenticated endpoints
///
/// Use this for endpoints that REQUIRE authentication:
/// - Profile
/// - Cart
/// - Orders
/// - Addresses
/// - Reviews
/// - etc.
///
/// For unauthenticated endpoints (register, login, etc.), use PublicApiService instead.
///
/// SOLID Principles Applied:
/// - Single Responsibility: Handles HTTP requests for protected endpoints only
/// - Open/Closed: Open for extension (child services), closed for modification
/// - Dependency Inversion: Depends on Dio abstraction, not concrete implementation
///
/// Clean Architecture:
/// - Lives in the Data Layer
/// - Communicates with external APIs
/// - Returns raw data (not domain entities)
/// - Automatically adds JWT authentication headers
abstract class BaseApiService {
  late final Dio _dio;

  BaseApiService() {
    _dio = DioClient.createProtectedDio();
  }

  /// Getter for accessing Dio instance in child classes if needed
  Dio get dio => _dio;

  // =========================
  // GET REQUEST
  // =========================

  /// Performs a GET request
  ///
  /// [endpoint] - API endpoint (e.g., '/products')
  /// [queryParameters] - Optional query params (e.g., {'page': 1, 'limit': 10})
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

  /// Performs a POST request
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

  /// Performs a PUT request (full update)
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

  /// Performs a PATCH request (partial update)
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

  /// Performs a DELETE request
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

  // =========================
  // UPLOAD FILE
  // =========================

  /// Uploads a file using multipart/form-data
  ///
  /// [endpoint] - API endpoint
  /// [filePath] - Path to the file
  /// [fieldName] - Form field name for the file (default: 'file')
  /// [data] - Additional form data
  ///
  /// Returns Response on success, throws String error message on failure
  Future<Response> uploadFile(
    String endpoint, {
    required String filePath,
    String fieldName = 'file',
    Map<String, dynamic>? data,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }
}
