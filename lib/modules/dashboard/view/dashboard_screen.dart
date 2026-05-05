import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:sejasa/modules/dashboard/bloc/dashboard_event.dart';
import 'package:sejasa/modules/dashboard/bloc/dashboard_state.dart';
import 'package:sejasa/modules/dashboard/widgets/build_project_list_widget.dart';

class DashboardScreen extends HookWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabBarController = useTabController(initialLength: 3);
    final theme = Theme.of(context);

    final dashboardBloc = context.read<DashboardBloc>();

    useEffect(() {
      dashboardBloc.add(LoadProjects(ProjectsListCategory.latest));
      return null;
    }, []);

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

        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.error) {
              return Center(child: Text("error: ${state.message}"));
            } else if (state.status == DashboardStatus.success) {
              return TabBarView(
                controller: tabBarController,

                children: [
                  BuildProjectListWidget(projects: state.projects),
                  BuildProjectListWidget(projects: state.projects, tipe: 1),
                  BuildProjectListWidget(projects: state.projects),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
