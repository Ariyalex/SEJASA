import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/domain/providers/remote_auth_provider.dart';

class RemoteAuthProviderImpl extends RemoteAuthProvider {
  final ApiService _apiService;
  final StorageService _storageService;
  RemoteAuthProviderImpl(this._apiService, this._storageService);

  @override
  Future<UserModel> getMyProfile() async {
    final response = await _apiService.get('/me');

    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<void> login(String email, String password) async {
    final result = await _apiService.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    final data = result.data['data'];

    final accessToken = data['access_token'] as String;
    final newRefreshToken = data['refresh_token'] as String;

    await _storageService.write('access_token', accessToken);
    await _storageService.write('refresh_token', newRefreshToken);
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _apiService.post('/logout', data: {'refresh_token': refreshToken});

    await _storageService.delete('refresh_token');
    await _storageService.delete('access_token');
  }

  @override
  Future<Map<String, String>> refreshAccessToken(String refreshToken) async {
    final response = await _apiService.post(
      '/refresh',
      data: {'refresh_token': refreshToken},
    );
    final data = response.data['data'] as Map<String, dynamic>;

    final accessToken = data['access_token'] as String;
    final newRefreshToken = data['refresh_token'] as String;

    await _storageService.write('access_token', accessToken);
    await _storageService.write('refresh_token', newRefreshToken);

    return {'access_token': accessToken, 'refresh_token': newRefreshToken};
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
  }) async {
    final requestData = <String, dynamic>{
      'name': name,
      'email': email,
      'passowrd1': passowrd1,
      'passowrd2': passowrd2,
      'latitude': latitude,
      'longitude': longitude,
      'account_type': accountType,
    };

    if (gender != null && gender.isNotEmpty) {
      requestData['gender'] = gender;
    }

    await _apiService.post('/register', data: requestData);
  }
}
