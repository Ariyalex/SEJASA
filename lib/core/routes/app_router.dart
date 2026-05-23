import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';
import 'package:sejasa/modules/auth/view/login_screen.dart';
import 'package:sejasa/modules/auth/view/register_screen.dart';
import 'package:sejasa/modules/chat/bloc/chat_bloc.dart';
import 'package:sejasa/modules/chat/view/chat_screen.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_bloc.dart';
import 'package:sejasa/modules/chat/view/chat_list_screen.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_bloc.dart';
import 'package:sejasa/modules/dashboard_project/view/dashboard_screen.dart';
import 'package:sejasa/modules/main_tab/view/main_tab.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_bloc.dart';
import 'package:sejasa/modules/project_detail/view/project_detail_screen.dart';
import 'package:sejasa/modules/project_form/bloc/project_form_bloc.dart';
import 'package:sejasa/modules/project_form/view/project_form_screen.dart';
import 'package:sejasa/modules/search/bloc/search_bloc.dart';
import 'package:sejasa/modules/search/bloc/search_event.dart';
import 'package:sejasa/modules/search/view/search_initial_screen.dart';
import 'package:sejasa/modules/search/view/search_result_screen.dart';

import 'package:sejasa/modules/splash/view/splash_screen.dart';
import 'package:sejasa/modules/profil_project/view/edit_profile_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = getIt<AuthBloc>().state;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Jangan redirect jika sedang di splash screen, biarkan SplashScreen yang menangani navigasi pertama
      if (state.matchedLocation == '/splash') return null;

      final isLoggedIn = authState.user != null;

      if (!isLoggedIn) {
        if (authState.status == AuthStatus.initial ||
            authState.status == AuthStatus.loading) {
          return null;
        }
        final isPublicRoute =
            state.matchedLocation == '/guest' ||
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/search' ||
            state.matchedLocation == '/search/result';

        if (isPublicRoute) return null;

        if (state.matchedLocation.startsWith('/project/')) {
          return '/login';
        }

        return '/guest';
      }

      if (isLoggedIn) {
        if (isLoggingIn || state.matchedLocation == '/guest') return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNamed.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNamed.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNamed.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/guest',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              DashboardProjectBloc(context.read<ProjectRepository>()),
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: "/",
        name: RouteNamed.mainTab,
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
        path: '/edit-profile',
        name: RouteNamed.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        name: RouteNamed.chat,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>;
          final projectId = extra['project_id'] as String?;
          final participantStatus = extra['participant_status'] as ParticipantStatusType?;
          final isOwner = extra['is_owner'] as bool? ?? false;
          final participantId = extra['user_id'] as String?;

          return BlocProvider(
            create: (context) => ChatBloc(
              context.read<ChatRepository>(),
              context.read<ProjectRepository>(),
            ),
            child: ChatScreen(
              id: id,
              name: extra['name'] ?? 'Unknown',
              avatarUrl: extra['avatar_url'],
              projectId: projectId,
              participantStatus: participantStatus,
              isOwner: isOwner,
              participantId: participantId,
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
            LogUtils.e("id tidak ada di parameter, jangan lupa tambahin id");
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
      GoRoute(
        path: '/project/:id/chats',
        name: RouteNamed.projectChatList,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BlocProvider(
            create: (context) => ChatListBloc(
              context.read<ChatRepository>(),
            ),
            child: ChatListScreen(projectId: id),
          );
        },
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
