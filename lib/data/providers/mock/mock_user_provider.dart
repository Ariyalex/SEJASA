import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';

class MockUserProvider extends RemoteUserProvider {
  @override
  Future<List<UserModel>> searchUsers(String keyword) async {
    await Future.delayed(const Duration(seconds: 1));

    final users = [
      const UserModel(
        id: 'user-1',
        name: 'Budi Santoso',
        rating: 4.8,
        address: 'Jakarta Selatan',
        profilePicture: 'https://i.pravatar.cc/150?u=user-1',
        gender: 'Laki-laki',
        totalProjectsCreated: 5,
        totalProjectsCompleted: 12,
        skills: ['Pertukangan', 'Kelistrikan', 'Pengecatan'],
      ),
      const UserModel(
        id: 'user-2',
        name: 'Siti Aminah',
        rating: 4.9,
        address: 'Bandung',
        profilePicture: 'https://i.pravatar.cc/150?u=user-2',
        gender: 'Perempuan',
        totalProjectsCreated: 2,
        totalProjectsCompleted: 25,
        skills: ['Kebersihan', 'Memasak', 'Menjahit'],
      ),
      const UserModel(
        id: 'user-3',
        name: 'Agus Setiawan',
        rating: 4.5,
        address: 'Surabaya',
        profilePicture: 'https://i.pravatar.cc/150?u=user-3',
        gender: 'Laki-laki',
        totalProjectsCreated: 10,
        totalProjectsCompleted: 8,
        skills: ['Mengemudi', 'Keamanan', 'Logistik'],
      ),
    ];

    if (keyword.isEmpty) return users;

    return users
        .where((user) =>
            user.name.toLowerCase().contains(keyword.toLowerCase()) ||
            user.skills.any((skill) =>
                skill.toLowerCase().contains(keyword.toLowerCase())))
        .toList();
  }
}
