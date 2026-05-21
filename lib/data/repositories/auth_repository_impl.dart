import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/data/payloads/register_payload.dart';
import 'package:sejasa/domain/providers/remote_auth_provider.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthProvider _remoteAuthProvider;

  AuthRepositoryImpl(this._remoteAuthProvider);

  @override
  Future<UserModel> getMyProfile() async {
    return await _remoteAuthProvider.getMyProfile();
  }

  @override
  Future<void> login(String email, String password) async {
    return await _remoteAuthProvider.login(email, password);
  }

  @override
  Future<void> logout(String refreshToken) async {
    return await _remoteAuthProvider.logout(refreshToken);
  }

  @override
  Future<Map<String, String>> refreshAccessToken(String refreshToken) async {
    return await _remoteAuthProvider.refreshAccessToken(refreshToken);
  }

  @override
  Future<void> register(RegisterPayload payload) async {
    return await _remoteAuthProvider.register(payload);
  }
}
