import 'package:sejasa/data/models/skill_model.dart';
import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/data/payloads/profile_update_payload.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';

class MockUserProvider extends RemoteUserProvider {
  @override
  Future<List<UserModel>> searchUsers(String keyword) async {
    await Future.delayed(const Duration(seconds: 1));

    final users = [
      const UserModel(
        id: 'user-1',
        name: 'Budi Santoso',
        email: 'budi@example.com',
        gender: GenderType.male,
        rating: 4.8,
        description: 'Tukang berpengalaman sejak 2010.',
        contact: '08123456789',
        address: 'Jakarta Selatan',
        latitude: -6.2088,
        longitude: 106.8456,
        profilePicture: 'https://i.pravatar.cc/150?u=user-1',
        skills: [
          SkillModel(id: 1, name: 'Pertukangan'),
          SkillModel(id: 2, name: 'Kelistrikan'),
          SkillModel(id: 3, name: 'Pengecatan'),
        ],
      ),
      const UserModel(
        id: 'user-2',
        name: 'Siti Aminah',
        email: 'siti@example.com',
        gender: GenderType.female,
        rating: 4.9,
        description: 'Spesialis kebersihan dan katering.',
        contact: '08234567890',
        address: 'Bandung',
        latitude: -6.9175,
        longitude: 107.6191,
        profilePicture: 'https://i.pravatar.cc/150?u=user-2',
        skills: [
          SkillModel(id: 1, name: 'Kebersihan'),
          SkillModel(id: 2, name: 'Memasak'),
          SkillModel(id: 3, name: 'Menjahit'),
        ],
      ),
      const UserModel(
        id: 'user-3',
        name: 'Agus Setiawan',
        email: 'agus@example.com',
        gender: GenderType.male,
        rating: 4.5,
        description: 'Driver profesional dan jujur.',
        contact: '08345678901',
        address: 'Surabaya',
        latitude: -7.2575,
        longitude: 112.7521,
        profilePicture: 'https://i.pravatar.cc/150?u=user-3',
        skills: [
          SkillModel(id: 1, name: 'Mengemudi'),
          SkillModel(id: 2, name: 'Keamanan'),
          SkillModel(id: 3, name: 'Logistik'),
        ],
      ),
    ];

    if (keyword.isEmpty) return users;

    return users
        .where(
          (user) =>
              user.name.toLowerCase().contains(keyword.toLowerCase()) ||
              (user.skills?.any(
                    (skill) => skill.name.toLowerCase().contains(
                      keyword.toLowerCase(),
                    ),
                  ) ??
                  false),
        )
        .toList();
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
