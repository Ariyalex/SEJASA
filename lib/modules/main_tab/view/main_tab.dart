import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_bloc.dart';
import 'package:sejasa/modules/dashboard_project/view/dashboard_screen.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_state.dart';
import 'package:sejasa/modules/taken_project/bloc/taken_project_bloc.dart';
import 'package:sejasa/modules/taken_project/view/taken_project_screen.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_bloc.dart';
import 'package:sejasa/modules/profil_project/view/profil_screen.dart';
import 'package:sejasa/modules/chat/view/chat_list_screen.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_bloc.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainTabBloc = context.read<MainTabBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: BlocBuilder<MainTabBloc, MainTabState>(
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            return PersistentTabView(
              controller: mainTabBloc.mainTabController,
              tabs: [
                PersistentTabConfig(
                  screen: BlocProvider(
                    create: (context) =>
                        DashboardProjectBloc(context.read<ProjectRepository>()),
                    child: DashboardScreen(),
                  ),
                  item: ItemConfig(
                    icon: const Icon(LucideIcons.layoutDashboard),
                    title: "Dashboard",
                    activeForegroundColor: theme.colorScheme.primary,
                  ),
                ),
                PersistentTabConfig(
                  screen: BlocProvider(
                    create: (context) =>
                        TakenProjectBloc(context.read<ProjectRepository>()),
                    child: const TakenProjectScreen(),
                  ),
                  item: ItemConfig(
                    icon: const Icon(Icons.assignment_outlined),
                    title: "Taken Project",
                    activeForegroundColor: theme.colorScheme.primary,
                  ),
                ),
                PersistentTabConfig.noScreen(
                  item: ItemConfig(
                    icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
                    activeForegroundColor: theme.primaryColor,
                  ),
                  onPressed: (BuildContext context) {
                    LogUtils.d("tombo jalan ini");
                    context.pushNamed(RouteNamed.addProject);
                  },
                ),
                PersistentTabConfig(
                  screen: BlocProvider(
                    create: (context) => ChatListBloc(
                      context.read<ChatRepository>(),
                      context.read<ProjectRepository>(),
                    ),
                    child: const ChatListScreen(),
                  ),
                  item: ItemConfig(
                    icon: const Icon(Icons.chat_outlined),
                    title: "Chats",
                    activeForegroundColor: theme.colorScheme.primary,
                  ),
                ),
                PersistentTabConfig(
                  screen: BlocProvider(
                    create: (context) => ProfilProjectBloc(
                      context.read<ProjectRepository>(),
                      context.read<UserRepository>(),
                      context.read<AuthRepository>(),
                    ),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final user = state.user;
                        if (user == null) {
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return ProfilScreen(userId: user.id);
                      },
                    ),
                  ),
                  item: ItemConfig(
                    icon: const Icon(Icons.person_outline_rounded),
                    title: "Profile",
                    activeForegroundColor: theme.colorScheme.primary,
                  ),
                ),
              ],
              navBarBuilder: (navbarConfig) {
                return Style15BottomNavBar(
                  navBarConfig: navbarConfig,
                  navBarDecoration: NavBarDecoration(
                    padding: EdgeInsets.only(top: 8),
                    border: BoxBorder.fromLTRB(
                      top: BorderSide(color: theme.dividerColor),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
