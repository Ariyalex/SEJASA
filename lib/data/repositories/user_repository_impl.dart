import 'package:sejasa/data/payloads/profile_update_payload.dart';
import 'package:sejasa/domain/entities/list_user_item_entity.dart';
import 'package:sejasa/domain/entities/skill_entity.dart';
import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final RemoteUserProvider _provider;

  UserRepositoryImpl(this._provider);

  @override
  Future<List<ListUserItemEntity>> searchUsers(String keyword) async {
    final users = await _provider.searchUsers(keyword);
    return users.map((e) => e.toEntity()).toList();
  }

  @override
  Future<SkillEntity> addMySkill(String name) async {
    final skill = await _provider.addMySkill(name);
    return skill.toEntity();
  }

  @override
  Future<void> deleteMySkill(String id) async {
    await _provider.deleteMySkill(id);
  }

  @override
  Future<SkillEntity> editMySkill(String id, String name) async {
    final skill = await _provider.editMySkill(id, name);
    return skill.toEntity();
  }

  @override
  Future<UserEntity> getUserProfile(String userId) async {
    final user = await _provider.getUserProfile(userId);
    return user.toEntity();
  }

  @override
  Future<UserEntity> updateMyProfile(UserUpdatePayload payload) async {
    final user = await _provider.updateMyProfile(payload);
    return user.toEntity();
  }
}
