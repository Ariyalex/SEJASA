import 'package:sejasa/data/models/user_model.dart';

abstract class RemoteUserProvider {
  Future<List<UserModel>> searchUsers(String keyword);
}
