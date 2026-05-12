import 'package:get_it/get_it.dart';
import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/core/services/connectivity_service.dart';
import 'package:sejasa/core/services/socket_service.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/data/providers/remote/chat_socket_provider.dart';
import 'package:sejasa/data/repositories/chat_repository_impl.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';

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

    // WebSocket implementation
    getIt.registerLazySingleton<SocketService>(() => SocketService());
    getIt.registerLazySingleton<ChatSocketProvider>(
      () => ChatSocketProviderImpl(getIt<SocketService>()),
    );
    getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(getIt<ChatSocketProvider>()),
    );
  }
}
