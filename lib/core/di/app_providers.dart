import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/socket_service.dart';
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

class AppProviders {
  static final isMocking = true;
  static List<RepositoryProvider> get repositoryProviers => [
    RepositoryProvider<RemoteProjectProvider>(
      create: (context) {
        if (isMocking) {
          return MockProjectProvider();
        } else {
          return RemoteProjectProviderImpl();
        }
      },
    ),

    RepositoryProvider<ProjectRepository>(
      create: (context) =>
          ProjectRepositoryImpl(context.read<RemoteProjectProvider>()),
    ),

    RepositoryProvider<RemoteUserProvider>(
      create: (context) {
        if (isMocking) {
          return MockUserProvider();
        } else {
          return RemoteUserProviderImpl();
        }
      },
    ),

    RepositoryProvider<UserRepository>(
      create: (context) =>
          UserRepositoryImpl(context.read<RemoteUserProvider>()),
    ),

    RepositoryProvider<ChatSocketProvider>(
      create: (context) {
        if (isMocking) {
          return MockChatSocketProvider();
        } else {
          return ChatSocketProviderImpl(getIt<SocketService>());
        }
      },
    ),

    RepositoryProvider<ChatRepository>(
      create: (context) =>
          ChatRepositoryImpl(context.read<ChatSocketProvider>()),
    ),
  ];

  static List<BlocProvider> get blocProviders => [];
}
