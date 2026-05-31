import 'package:sejasa/data/models/skill_model.dart';
import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/data/payloads/profile_update_payload.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';

class MockUserProvider extends RemoteUserProvider {
  @override
  Future<List<UserModel>> searchUsers(String keyword) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateMyProfile(UserUpdatePayload payload) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserProfile(String userId) {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<SkillModel> addMySkill(String name) {
    // TODO: implement addMySkill
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMySkill(String id) {
    // TODO: implement deleteMySkill
    throw UnimplementedError();
  }

  @override
  Future<SkillModel> editMySkill(String id, String name) {
    // TODO: implement editMySkill
    throw UnimplementedError();
  }
}
