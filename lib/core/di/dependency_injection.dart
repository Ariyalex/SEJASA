import 'package:get_it/get_it.dart';
import 'package:sejasa/core/services/storage_service.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    getIt.registerSingleton<StorageService>(StorageService());
  }
}
