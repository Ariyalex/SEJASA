import 'package:sejasa/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> searchUsers(String keyword);
}
