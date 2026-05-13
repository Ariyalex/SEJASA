import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/my_outline_button.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_bloc.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_event.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_state.dart';
import 'package:sejasa/core/widgets/build_project_list_fetch_page_widget.dart';

class DashboardScreen extends HookWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabBarController = useTabController(initialLength: 3);
    final theme = Theme.of(context);

    final dashboardBloc = context.read<DashboardProjectBloc>();

    useEffect(() {
      dashboardBloc.add(
        LoadInitialProjectsEvent(DashboardProjectTabType.closest),
      );
      dashboardBloc.add(
        LoadInitialProjectsEvent(DashboardProjectTabType.latest),
      );
      dashboardBloc.add(
        LoadInitialProjectsEvent(DashboardProjectTabType.popular),
      );
      return null;
    }, []);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: FlutterLogo(),
              floating: true,
              snap: true,
              pinned: true,
              surfaceTintColor: Colors.transparent,
              actionsPadding: EdgeInsets.symmetric(horizontal: 8),
              actions: [
                IconButton.filled(
                  onPressed: () {
                    context.pushNamed(RouteNamed.searchInitial);
                  },
                  icon: Icon(
                    LucideIcons.search,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                MyOutlineButton(onPressed: () {}, child: Text("Masuk")),
              ],
              bottom: TabBar(
                controller: tabBarController,
                splashBorderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
                tabs: [
                  Tab(text: "Terdekat"),
                  Tab(text: "Terbaru"),
                  Tab(text: "Terpopuler"),
                ],
              ),
            ),
          ];
        },

        body: BlocBuilder<DashboardProjectBloc, DashboardProjectState>(
          builder: (context, state) {
            if (state.status == DashboardProjectStatus.error) {
              return Center(child: Text("error: ${state.message}"));
            } else {
              return TabBarView(
                controller: tabBarController,
                children: [
                  BuildProjectListFetchPageWidget(
                    projects: state.closest.projects,
                    hasReachedMax: state.closest.hasReachedMax,
                    isFetchingMore: state.closest.isFetchingMore,
                    isLoading: state.closest.isFetchingInitial,
                    onRefresh: () async {
                      dashboardBloc.add(
                        LoadInitialProjectsEvent(
                          DashboardProjectTabType.closest,
                        ),
                      );
                    },

                    onLoadMore: () {
                      dashboardBloc.add(
                        LoadMoreProjectsEvent(DashboardProjectTabType.closest),
                      );
                    },
                  ),
                  BuildProjectListFetchPageWidget(
                    projects: state.latest.projects,
                    hasReachedMax: state.latest.hasReachedMax,
                    isFetchingMore: state.latest.isFetchingMore,
                    isLoading: state.latest.isFetchingInitial,
                    onRefresh: () async {
                      dashboardBloc.add(
                        LoadInitialProjectsEvent(
                          DashboardProjectTabType.latest,
                        ),
                      );
                    },

                    onLoadMore: () {
                      dashboardBloc.add(
                        LoadMoreProjectsEvent(DashboardProjectTabType.latest),
                      );
                    },
                  ),
                  BuildProjectListFetchPageWidget(
                    projects: state.popular.projects,
                    hasReachedMax: state.popular.hasReachedMax,
                    isFetchingMore: state.popular.isFetchingMore,
                    isLoading: state.popular.isFetchingInitial,
                    onRefresh: () async {
                      dashboardBloc.add(
                        LoadInitialProjectsEvent(
                          DashboardProjectTabType.popular,
                        ),
                      );
                    },

                    onLoadMore: () {
                      dashboardBloc.add(
                        LoadMoreProjectsEvent(DashboardProjectTabType.popular),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
