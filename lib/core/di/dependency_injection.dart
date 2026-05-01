import 'package:get_it/get_it.dart';
import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/core/services/connectivity_service.dart';
import 'package:sejasa/core/services/storage_service.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    getIt.registerSingletonAsync<StorageService>(() async {
      final storageService = StorageService();
      await storageService.initStorage();
      return storageService;
    });

    getIt.registerSingletonAsync<ConnectivityService>(() async {
      final connectivityService = ConnectivityService();
      await connectivityService.init();
      return connectivityService;
    });

    getIt.registerSingletonAsync<ApiService>(() async {
      final apiService = ApiService(
        getIt<StorageService>(),
        getIt<ConnectivityService>(),
      );
      apiService.initializeDio();
      return apiService;
    }, dependsOn: [StorageService, ConnectivityService]);
  }
}
