import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/widgets/build_project_list_widget.dart';
import 'package:sejasa/core/widgets/my_tab_chip.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/taken_project/bloc/taken_project_bloc.dart';
import 'package:sejasa/modules/taken_project/bloc/taken_project_event.dart';
import 'package:sejasa/modules/taken_project/bloc/taken_project_state.dart';

class TakenProjectScreen extends HookWidget {
  const TakenProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabBarController = useTabController(initialLength: 3);

    final projectBloc = context.read<TakenProjectBloc>();
    final authBloc = context.read<AuthBloc>();

    useEffect(() {
      projectBloc.add(LoadTakenPendingProjects(authBloc.state.user!.id));
      projectBloc.add(LoadTakenAcceptedProjects(authBloc.state.user!.id));
      projectBloc.add(LoadTakenRejectedProjects(authBloc.state.user!.id));
      return null;
    }, []);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                "Project Diambil",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              floating: true,
              snap: true,
              pinned: true,
              surfaceTintColor: Colors.transparent,

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: tabBarController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      splashBorderRadius: const BorderRadius.only(
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
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.hintColor,
                                ),
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
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.hintColor,
                                ),
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
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.hintColor,
                                ),
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
                              TakenProjectBloc,
                              TakenProjectState,
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
                                                SetTakenProjectFilterType(status),
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

        body: BlocBuilder<TakenProjectBloc, TakenProjectState>(
          builder: (context, state) {
            if (state.status == TakenProjectStatus.error) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return TabBarView(
                controller: tabBarController,
                children: [
                  BuildProjectListWidget(
                    projects: state.filteredPendingProjects,
                    listType: ProjectListType.taken,
                    takenStatus: 'pending',
                    onRefresh: () async {
                      projectBloc.add(
                        LoadTakenPendingProjects(authBloc.state.user!.id),
                      );
                    },
                    isLoading:
                        state.status != TakenProjectStatus.error &&
                        state.isFetchingPendingProjects,
                  ),
                  BuildProjectListWidget(
                    projects: state.filteredAcceptedProjects,
                    listType: ProjectListType.taken,
                    takenStatus: 'accepted',
                    onRefresh: () async {
                      projectBloc.add(
                        LoadTakenAcceptedProjects(authBloc.state.user!.id),
                      );
                    },
                    isLoading:
                        state.status != TakenProjectStatus.error &&
                        state.isFetchingAcceptedProjects,
                  ),
                  BuildProjectListWidget(
                    projects: state.filteredRejectedProjects,
                    listType: ProjectListType.taken,
                    takenStatus: 'rejected',
                    onRefresh: () async {
                      projectBloc.add(
                        LoadTakenRejectedProjects(authBloc.state.user!.id),
                      );
                    },
                    isLoading:
                        state.status != TakenProjectStatus.error &&
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
