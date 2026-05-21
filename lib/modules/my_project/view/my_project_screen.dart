import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/widgets/build_project_list_widget.dart';
import 'package:sejasa/core/widgets/my_tab_chip.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_bloc.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_event.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_state.dart';

class MyProjectScreen extends HookWidget {
  const MyProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabBarController = useTabController(initialLength: 3);

    final projectBloc = context.read<MyProjectBloc>();
    final authBloc = context.read<AuthBloc>();

    useEffect(() {
      projectBloc.add(LoadMyPendingProjects(authBloc.state.user!.id));
      projectBloc.add(LoadMyAcceptedProjects(authBloc.state.user!.id));
      projectBloc.add(LoadMyRejectedProjects(authBloc.state.user!.id));
      return null;
    }, []);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: FlutterLogo(),
              title: Text("Project Diambil"),
              floating: true,
              snap: true,
              pinned: true,
              surfaceTintColor: Colors.transparent,

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(105),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: tabBarController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      splashBorderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                      tabs: [
                        Tab(
                          child: Column(
                            children: [
                              Text(
                                "Pending",
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                "Menunggu konfirmasi",
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Accepted",
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                "Permintaan Partisipasi diterima",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            children: [
                              Text(
                                "Rejected",
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                "Permintaan Partisipasi ditolak",
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 12,
                        ),
                        child:
                            BlocSelector<
                              MyProjectBloc,
                              MyProjectState,
                              ProjectFilterType
                            >(
                              selector: (state) {
                                return state.filterType;
                              },
                              builder: (context, filterType) {
                                return Row(
                                  spacing: 6,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: ProjectFilterType.values
                                      .map<Widget>((status) {
                                        final isSelected = filterType == status;
                                        return MyTabChip(
                                          title: status.display,
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            if (selected) {
                                              projectBloc.add(
                                                SetMyProjectFilterType(status),
                                              );
                                            }
                                          },
                                        );
                                      })
                                      .toList(),
                                );
                              },
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },

        body: BlocBuilder<MyProjectBloc, MyProjectState>(
          builder: (context, state) {
            if (state.status == MyProjectStatus.error) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return TabBarView(
                controller: tabBarController,
                children: [
                  BuildProjectListWidget(
                    projects: state.filteredPendingProjects,
                    onRefresh: () async {
                      projectBloc.add(
                        LoadMyPendingProjects(authBloc.state.user!.id),
                      );
                    },
                    isLoading:
                        state.status != MyProjectStatus.error &&
                        state.isFetchingPendingProjects,
                  ),
                  BuildProjectListWidget(
                    projects: state.filteredAcceptedProjects,
                    isMyProjects: true,
                    onRefresh: () async {
                      projectBloc.add(
                        LoadMyAcceptedProjects(authBloc.state.user!.id),
                      );
                    },
                    isLoading:
                        state.status != MyProjectStatus.error &&
                        state.isFetchingAcceptedProjects,
                  ),
                  BuildProjectListWidget(
                    projects: state.filteredRejectedProjects,
                    isMyProjects: true,
                    onRefresh: () async {
                      projectBloc.add(
                        LoadMyRejectedProjects(authBloc.state.user!.id),
                      );
                    },
                    isLoading:
                        state.status != MyProjectStatus.error &&
                        state.isFetchingRejectedProjects,
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
