import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/widgets/build_project_list_widget.dart';
import 'package:sejasa/core/widgets/my_tab_chip.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_bloc.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_event.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_state.dart';

class MyProjectScreen extends HookWidget {
  const MyProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabBarController = useTabController(initialLength: 2);

    final projectBloc = context.read<MyProjectBloc>();

    useEffect(() {
      projectBloc.add(LoadMyUploadedProjects());
      projectBloc.add(LoadMyTakenProjects());
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
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
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
                    projects: state.filteredTakenProjects,
                    onRefresh: () async {
                      projectBloc.add(LoadMyTakenProjects());
                    },
                    isLoading:
                        state.status != MyProjectStatus.error &&
                        state.isFetchingProjectTaken,
                  ),
                  BuildProjectListWidget(
                    projects: state.filteredUploadedProjects,
                    isMyProjects: true,
                    onRefresh: () async {
                      projectBloc.add(LoadMyUploadedProjects());
                    },
                    isLoading:
                        state.status != MyProjectStatus.error &&
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
