import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/services/connectivity_service.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/domain/repositories/file_repository.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_bloc.dart';

class AppProviders {
  static List<RepositoryProvider> get repositoryProviders => [
    RepositoryProvider<LocationService>.value(
      value: getIt<LocationService>(),
    ),
    RepositoryProvider<ConnectivityService>.value(
      value: getIt<ConnectivityService>(),
    ),
    RepositoryProvider<StorageService>.value(
      value: getIt<StorageService>(),
    ),
    RepositoryProvider<FileRepository>.value(
      value: getIt<FileRepository>(),
    ),
    RepositoryProvider<AuthRepository>.value(
      value: getIt<AuthRepository>(),
    ),
    RepositoryProvider<ProjectRepository>.value(
      value: getIt<ProjectRepository>(),
    ),
    RepositoryProvider<UserRepository>.value(
      value: getIt<UserRepository>(),
    ),
    RepositoryProvider<ChatRepository>.value(
      value: getIt<ChatRepository>(),
    ),
  ];

  static List<BlocProvider> get blocProviders => [
    BlocProvider<AuthBloc>.value(
      value: getIt<AuthBloc>(),
    ),
    BlocProvider<MainTabBloc>.value(
      value: getIt<MainTabBloc>(),
    ),
  ];
}
