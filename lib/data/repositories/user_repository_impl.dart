import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final RemoteUserProvider _provider;

  UserRepositoryImpl(this._provider);

  @override
  Future<List<UserEntity>> searchUsers(String keyword) async {
    final users = await _provider.searchUsers(keyword);
    return users.map((e) => e.toEntity()).toList();
  }
}
