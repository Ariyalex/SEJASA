import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_state.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainTabBloc = context.read<MainTabBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<MainTabBloc, MainTabState>(
        buildWhen: (previous, current) => false,
        builder: (context, state) {
          return PersistentTabView(
            controller: mainTabBloc.mainTabController,
            tabs: [
              PersistentTabConfig(
                screen: Scaffold(),
                item: ItemConfig(
                  icon: const Icon(LucideIcons.layoutDashboard),
                  title: "Dashboard",
                ),
              ),
              PersistentTabConfig(
                screen: Scaffold(),
                item: ItemConfig(
                  icon: const Icon(Icons.assignment_outlined),
                  title: "My Project",
                ),
              ),
              PersistentTabConfig.noScreen(
                item: ItemConfig(
                  icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
                ),
                onPressed: (BuildContext context) {
                  LogUtils.d('belum ada aksi');
                },
              ),
              PersistentTabConfig(
                screen: Scaffold(),
                item: ItemConfig(icon: const Icon(Icons.chat_outlined)),
              ),
              PersistentTabConfig(
                screen: Scaffold(),
                item: ItemConfig(
                  icon: const Icon(Icons.person_outline_rounded),
                ),
              ),
            ],
            navBarBuilder: (navbarConfig) {
              return Style13BottomNavBar(navBarConfig: navbarConfig);
            },
          );
        },
      ),
    );
  }
}
