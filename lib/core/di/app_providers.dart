import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/data/providers/mock/mock_project_provider.dart';
import 'package:sejasa/data/providers/remote/remote_project_provider_impl.dart';
import 'package:sejasa/data/repositories/project_repository_impl.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';

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
  ];

  static List<BlocProvider> get blocProviders => [];
}
