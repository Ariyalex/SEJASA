import 'package:flutter/material.dart';
import 'package:sejasa/core/widgets/project_item_widget.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/value_objects/project_status.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuildProjectListWidget extends StatelessWidget {
  final RefreshCallback onRefresh;
  final List<Project> projects;
  final bool isLoading;
  final bool isMyProjects;
  const BuildProjectListWidget({
    super.key,
    required this.onRefresh,
    required this.projects,
    required this.isLoading,
    this.isMyProjects = false,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: isLoading ? 5 : projects.length,
        separatorBuilder: (context, index) => SizedBox(height: 6),
        itemBuilder: (context, index) {
          if (isLoading) {
            return Skeletonizer(
              child: ProjectItemWidget(
                isMyProject: isMyProjects,
                project: Project(
                  id: "",
                  title: 'loading data',
                  address: "ngawi",
                  status: ProjectStatus.going,
                  distance: '100km',
                  participant: '6/7 peserta',
                  category: 'random',
                  ownerName: "gatawu",
                  ownerRating: 5,
                ),
              ),
            );
          }
          return ProjectItemWidget(
            project: projects[index],
            isMyProject: isMyProjects,
          );
        },
      ),
    );
  }
}
