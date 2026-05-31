import 'package:sejasa/data/models/skill_model.dart';
import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/data/payloads/profile_update_payload.dart';

abstract class RemoteUserProvider {
  Future<List<UserModel>> searchUsers(String keyword);
  Future<UserModel> updateMyProfile(UserUpdatePayload payload);
  Future<UserModel> getUserProfile(String userId);
  Future<SkillModel> addMySkill(String name);
  Future<SkillModel> editMySkill(String id, String name);
  Future<void> deleteMySkill(String id);
}
