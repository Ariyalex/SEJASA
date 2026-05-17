import 'package:get_it/get_it.dart';
import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/core/services/connectivity_service.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/services/socket_service.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/data/providers/remote/remote_auth_provider_impl.dart';
import 'package:sejasa/data/repositories/auth_repository_impl.dart';
import 'package:sejasa/domain/providers/remote_auth_provider.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';

import 'package:sejasa/data/providers/mock/mock_chat_socket_provider.dart';
import 'package:sejasa/data/providers/mock/mock_project_provider.dart';
import 'package:sejasa/data/providers/mock/mock_user_provider.dart';
import 'package:sejasa/data/providers/remote/chat_socket_provider.dart';
import 'package:sejasa/data/providers/remote/remote_project_provider_impl.dart';
import 'package:sejasa/data/providers/remote/remote_user_provider_impl.dart';
import 'package:sejasa/data/repositories/chat_repository_impl.dart';
import 'package:sejasa/data/repositories/project_repository_impl.dart';
import 'package:sejasa/data/repositories/user_repository_impl.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static final isMocking = false;

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

    // Auth implementation
    getIt.registerLazySingleton<RemoteAuthProvider>(
      () =>
          RemoteAuthProviderImpl(getIt<ApiService>(), getIt<StorageService>()),
    );
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<RemoteAuthProvider>()),
    );
    getIt.registerLazySingleton<AuthBloc>(
      () =>
          AuthBloc(getIt<AuthRepository>(), getIt<StorageService>())
            ..add(AuthCheckRequested()),
    );

    getIt.registerSingleton<LocationService>(LocationService());

    // Project implementation
    getIt.registerLazySingleton<RemoteProjectProvider>(() {
      if (isMocking) return MockProjectProvider();
      return RemoteProjectProviderImpl(getIt<ApiService>());
    });
    getIt.registerLazySingleton<ProjectRepository>(
      () => ProjectRepositoryImpl(getIt<RemoteProjectProvider>()),
    );

    // User implementation
    getIt.registerLazySingleton<RemoteUserProvider>(() {
      if (isMocking) return MockUserProvider();
      return RemoteUserProviderImpl();
    });
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt<RemoteUserProvider>()),
    );

    // Chat implementation
    getIt.registerLazySingleton<ChatSocketProvider>(() {
      if (isMocking) return MockChatSocketProvider();
      return ChatSocketProviderImpl(getIt<SocketService>());
    });
    getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(getIt<ChatSocketProvider>()),
    );
  }
}
