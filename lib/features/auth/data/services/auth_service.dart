import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/public_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

/// Authentication Service - Handles all PUBLIC auth endpoints
/// This service uses PublicApiService to ensure NO auth tokens are sent
/// with registration, login, and password recovery requests.
class AuthService extends PublicApiService {
  Future<Response> register({
    required String email,
    required String password,
    String? phone,
    String? avatar,
  }) async {
    return await post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
        if (avatar != null) 'avatar': avatar,
      },
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> refreshToken({
    required String refreshToken,
  }) async {
    return await post(
      ApiEndpoints.refreshToken,
      data: {
        'refresh': refreshToken,
      },
    );
  }

  Future<Response> forgotPassword({
    required String email,
  }) async {
    return await post(
      ApiEndpoints.forgotPassword,
      data: {
        'email': email,
      },
    );
  }

  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await post(
      ApiEndpoints.verifyOtp,
      data: {
        'email': email,
        'otp': otp,
      },
    );
  }

  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      },
    );
  }
}
