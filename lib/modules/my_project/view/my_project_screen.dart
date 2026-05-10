import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/widgets/build_project_list_widget.dart';
import 'package:sejasa/core/widgets/my_tab_chip.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';
import 'package:sejasa/modules/my_project/bloc/project_bloc.dart';
import 'package:sejasa/modules/my_project/bloc/project_event.dart';
import 'package:sejasa/modules/my_project/bloc/project_state.dart';

class MyProjectScreen extends HookWidget {
  const MyProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabBarController = useTabController(initialLength: 2);

    final projectBloc = context.read<ProjectBloc>();

    useEffect(() {
      projectBloc.add(LoadUploadedProjects());
      projectBloc.add(LoadTakenProjects());
      return null;
    }, []);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: FlutterLogo(),
              title: Text("SeJasa"),
              floating: true,
              snap: true,
              pinned: true,
              surfaceTintColor: Colors.transparent,

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(98),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: tabBarController,
                      splashBorderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      tabs: [
                        Tab(text: "Project Diambil", height: 40),
                        Tab(text: "Project Diunggah", height: 40),
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
                              ProjectBloc,
                              ProjectState,
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
                                                SetProjectFilterType(status),
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

        body: BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, state) {
            if (state.status == ProjectBlocStatus.error) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return TabBarView(
                controller: tabBarController,
                children: [
                  BuildProjectListWidget(
                    projects: state.filteredTakenProjects,
                    onRefresh: () async {
                      projectBloc.add(LoadTakenProjects());
                    },
                    isLoading:
                        state.status != ProjectBlocStatus.error &&
                        state.isFetchingProjectTaken,
                  ),
                  BuildProjectListWidget(
                    projects: state.filteredUploadedProjects,
                    isMyProjects: true,
                    onRefresh: () async {
                      projectBloc.add(LoadUploadedProjects());
                    },
                    isLoading:
                        state.status != ProjectBlocStatus.error &&
                        state.isFetchingProjectUploaded,
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
