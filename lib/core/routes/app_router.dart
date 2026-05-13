import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';
import 'package:sejasa/modules/chat/bloc/chat_bloc.dart';
import 'package:sejasa/modules/chat/bloc/chat_event.dart';
import 'package:sejasa/modules/chat/view/chat_screen.dart';
import 'package:sejasa/modules/main_tab/view/main_tab.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_bloc.dart';
import 'package:sejasa/modules/project_detail/view/project_detail_screen.dart';
import 'package:sejasa/modules/project_form/bloc/project_form_bloc.dart';
import 'package:sejasa/modules/project_form/view/project_form_screen.dart';
import 'package:sejasa/modules/search/bloc/search_bloc.dart';
import 'package:sejasa/modules/search/bloc/search_event.dart';
import 'package:sejasa/modules/search/view/search_initial_screen.dart';
import 'package:sejasa/modules/search/view/search_result_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: "/",
        name: RouteNamed.dashboard,
        builder: (context, state) => MainTab(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => SearchBloc(
              projectRepository: context.read<ProjectRepository>(),
              userRepository: context.read<UserRepository>(),
              storageService: getIt<StorageService>(),
            )..add(SearchStarted()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/search',
            name: RouteNamed.searchInitial,
            builder: (context, state) => SearchInitialScreen(),
          ),
          GoRoute(
            path: '/search/result',
            name: RouteNamed.searchResult,
            builder: (context, state) => SearchResultScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/project/add',
        name: RouteNamed.addProject,
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                ProjectFormBloc(context.read<ProjectRepository>()),
            child: ProjectFormScreen(),
          );
        },
      ),
      GoRoute(
        path: '/project/edit',
        name: RouteNamed.editProject,
        builder: (context, state) {
          final project = state.extra as ProjectEntity;
          return BlocProvider(
            create: (context) =>
                ProjectFormBloc(context.read<ProjectRepository>()),
            child: ProjectFormScreen(initialProject: project),
          );
        },
      ),
      GoRoute(
        path: '/chat/:id',
        name: RouteNamed.chat,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>;
          final projectId = extra['project_id'] as String?;

          return BlocProvider(
            create: (context) => ChatBloc(
              context.read<ChatRepository>(),
              context.read<ProjectRepository>(),
            )..add(ChatStarted(projectId)),
            child: ChatScreen(
              id: id,
              name: extra['name'] ?? 'Unknown',
              avatarUrl: extra['avatar_url'],
              projectId: projectId,
            ),
          );
        },
      ),
      GoRoute(
        path: '/project/:id',
        name: RouteNamed.projectDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final extra = state.extra as Map<String, dynamic>;
          if (id == null) {
            LogUtils.e(
              "id tidak ada ada di parameter, jangan lupa tambahin id",
            );
          }
          final isReadMore = extra['read_more'] as bool?;

          return BlocProvider(
            create: (context) =>
                ProjectDetailBloc(context.read<ProjectRepository>()),
            child: ProjectDetailScreen(
              id: id!,
              isOwner: extra['is_owner'],
              isReadMore: isReadMore ?? false,
            ),
          );
        },
      ),
    ],
  );
}
