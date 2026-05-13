import 'package:sejasa/data/models/user_model.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';

class RemoteUserProviderImpl extends RemoteUserProvider {
  @override
  Future<List<UserModel>> searchUsers(String keyword) {
    throw UnimplementedError();
  }
}
