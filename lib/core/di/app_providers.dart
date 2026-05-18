import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';
import 'package:sejasa/domain/providers/remote_auth_provider.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';
import 'package:sejasa/domain/providers/remote_user_provider.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_bloc.dart';

class AppProviders {
  static List<RepositoryProvider> get repositoryProviders => [
    RepositoryProvider<RemoteAuthProvider>.value(
      value: getIt<RemoteAuthProvider>(),
    ),
    RepositoryProvider<AuthRepository>.value(
      value: getIt<AuthRepository>(),
    ),
    RepositoryProvider<RemoteProjectProvider>.value(
      value: getIt<RemoteProjectProvider>(),
    ),
    RepositoryProvider<ProjectRepository>.value(
      value: getIt<ProjectRepository>(),
    ),
    RepositoryProvider<RemoteUserProvider>.value(
      value: getIt<RemoteUserProvider>(),
    ),
    RepositoryProvider<UserRepository>.value(
      value: getIt<UserRepository>(),
    ),
    RepositoryProvider<ChatSocketProvider>.value(
      value: getIt<ChatSocketProvider>(),
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
