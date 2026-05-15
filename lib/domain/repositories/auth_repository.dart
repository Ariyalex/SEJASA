import 'package:sejasa/data/models/user_model.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register({
    required String name,
    required String email,
    required String passowrd1,
    required String passowrd2,
    String? gender,
    required String accountType,
    required double latitude,
    required double longitude,
  });
  Future<UserModel> getMyProfile();
  Future<void> logout(String refreshToken);
  Future<Map<String, String>> refreshAccessToken(String refreshToken);
}
