import 'package:sejasa/data/payloads/profile_update_payload.dart';
import 'package:sejasa/domain/entities/list_user_item_entity.dart';
import 'package:sejasa/domain/entities/skill_entity.dart';
import 'package:sejasa/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<ListUserItemEntity>> searchUsers(String keyword);
  Future<UserEntity> updateMyProfile(UserUpdatePayload payload);
  Future<UserEntity> getUserProfile(String userId);
  Future<SkillEntity> addMySkill(String name);
  Future<SkillEntity> editMySkill(String id, String name);
  Future<void> deleteMySkill(String id);
}
