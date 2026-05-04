import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/value_objects/project_status.dart';
import 'package:sejasa/modules/dashboard/widgets/build_project_list_widget.dart';

final dummyProject = Project(
  id: '1',
  title: 'nggak tawu',
  address: 'belum',
  status: ProjectStatus.hiring,
  distance: '100m',
  participant: '6/7',
  category: 'testing',
  ownerName: 'joko',
  ownerRating: 1.67,
);

class DashboardScreen extends HookWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabBarController = useTabController(initialLength: 3);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.focusColor,

      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: FlutterLogo(),
              floating: true,
              snap: true,
              pinned: true,
              actions: [
                IconButton.filled(
                  onPressed: () {},
                  icon: Icon(
                    LucideIcons.search,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
              bottom: TabBar(
                controller: tabBarController,
                tabs: [
                  Tab(text: "Terdekat"),
                  Tab(text: "Terbaru"),
                  Tab(text: "Terpopuler"),
                ],
              ),
            ),
          ];
        },

        body: TabBarView(
          controller: tabBarController,

          children: [
            BuildProjectListWidget(projects: [dummyProject]),
            BuildProjectListWidget(projects: [dummyProject]),
            BuildProjectListWidget(projects: [dummyProject]),
          ],
        ),
      ),
    );
  }
}
