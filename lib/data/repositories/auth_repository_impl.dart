import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/domain/providers/remote_auth_provider.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthProvider _remoteAuthProvider;

  AuthRepositoryImpl(this._remoteAuthProvider);

  @override
  Future<UserModel> getMyProfile() {
    return _remoteAuthProvider.getMyProfile();
  }

  @override
  Future<void> login(String email, String password) {
    return _remoteAuthProvider.login(email, password);
  }

  @override
  Future<void> logout(String refreshToken) {
    return _remoteAuthProvider.logout(refreshToken);
  }

  @override
  Future<Map<String, String>> refreshAccessToken(String refreshToken) {
    return _remoteAuthProvider.refreshAccessToken(refreshToken);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String passowrd1,
    required String passowrd2,
    String? gender,
    required String accountType,
    required double latitude,
    required double longitude,
  }) {
    return _remoteAuthProvider.register(
      name: name,
      email: email,
      passowrd1: passowrd1,
      passowrd2: passowrd2,
      gender: gender,
      accountType: accountType,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
