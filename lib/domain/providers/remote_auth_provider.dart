import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/data/payloads/register_payload.dart';

abstract class RemoteAuthProvider {
  Future<void> login(String email, String password);
  Future<void> register(RegisterPayload payload);
  Future<UserModel> getMyProfile();
  Future<void> logout(String refreshToken);
  Future<Map<String, String>> refreshAccessToken(String refreshToken);
}
