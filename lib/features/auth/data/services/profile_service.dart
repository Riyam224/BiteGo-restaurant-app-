import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/base_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

/// Profile Service - Handles all PROTECTED profile endpoints
/// This service uses BaseApiService (Protected) to ensure auth tokens
/// are automatically included in requests.
class ProfileService extends BaseApiService {
  Future<Response> getProfile() async {
    return await get(ApiEndpoints.profile);
  }

  Future<Response> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    return await put(
      ApiEndpoints.profile,
      data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (avatar != null) 'avatar': avatar,
      },
    );
  }
}
