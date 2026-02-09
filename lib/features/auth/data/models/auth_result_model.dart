import 'package:restaurant_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:restaurant_app/features/auth/data/models/user_model.dart';
import 'package:restaurant_app/features/auth/domain/entities/auth_result.dart';

class AuthResultModel extends AuthResult {
  const AuthResultModel({
    required super.user,
    required super.tokens,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokensModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'tokens': (tokens as AuthTokensModel).toJson(),
    };
  }
}
