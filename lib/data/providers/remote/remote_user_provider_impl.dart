import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/data/models/list_user_item_model.dart';
import 'package:sejasa/data/models/skill_model.dart';
import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/data/payloads/profile_update_payload.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';

class RemoteUserProviderImpl extends RemoteUserProvider {
  final ApiService _apiService;
  RemoteUserProviderImpl(this._apiService);
  @override
  Future<List<ListUserItemModel>> searchUsers(String keyword) async {
    final response = await _apiService.get(
      '/user',
      queryParameters: {'name': keyword},
    );

    final rawData = response.data['data'] as List?;

    return List<ListUserItemModel>.from(
      rawData?.map((e) => ListUserItemModel.fromJson(e)) ?? [],
    );
  }

  @override
  Future<UserModel> updateMyProfile(UserUpdatePayload payload) async {
    final response = await _apiService.patch('/me', data: payload.toJson());

    final rawData = response.data['data'];

    return UserModel.fromJson(rawData);
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    final response = await _apiService.get('/user/$userId');

    final rawData = response.data['data'];

    return UserModel.fromJson(rawData);
  }

  @override
  Future<SkillModel> addMySkill(String name) async {
    final response = await _apiService.post(
      '/user/skills',
      data: {'name': name},
    );

    final rawData = response.data['data'];

    return SkillModel.fromJson(rawData);
  }

  @override
  Future<void> deleteMySkill(String id) async {
    await _apiService.delete('/user/skills/$id');
  }

  @override
  Future<SkillModel> editMySkill(String id, String name) async {
    final response = await _apiService.post(
      '/user/skills/$id',
      data: {'name': name},
    );

    final rawData = response.data['data'];

    return SkillModel.fromJson(rawData);
  }
}
