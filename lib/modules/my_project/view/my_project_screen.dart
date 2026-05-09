import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/widgets/build_project_list_widget.dart';
import 'package:sejasa/core/widgets/my_tab_chip.dart';
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
                      tabs: [
                        Tab(text: "Project Diambil"),
                        Tab(text: "Project Diunggah"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyTabChip(title: "Berlangsung"),
                          MyTabChip(title: "Dibatalkan"),
                          MyTabChip(title: "Selesai"),
                        ],
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
                    projects: state.projectsTaken,
                    onRefresh: () async {
                      projectBloc.add(LoadTakenProjects());
                    },
                    isLoading:
                        state.status != ProjectBlocStatus.error &&
                        state.status != ProjectBlocStatus.success,
                  ),
                  BuildProjectListWidget(
                    projects: state.projectsUploaded,
                    isMyProjects: true,
                    onRefresh: () async {
                      projectBloc.add(LoadUploadedProjects());
                    },
                    isLoading:
                        state.status != ProjectBlocStatus.error &&
                        state.status != ProjectBlocStatus.success,
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
