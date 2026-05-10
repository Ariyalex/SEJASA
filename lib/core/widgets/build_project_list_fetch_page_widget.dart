import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/core/widgets/project_item_widget.dart';
import 'package:sejasa/data/value_objects/project_status.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuildProjectListFetchPageWidget extends HookWidget {
  final List<Project> projects;
  final bool isMyProjects;

  final bool isFetchingMore;
  final bool hasReachedMax;

  final RefreshCallback onRefresh;
  final VoidCallback onLoadMore;

  final bool isLoading;

  const BuildProjectListFetchPageWidget({
    super.key,
    required this.projects,
    this.isMyProjects = false,
    required this.isFetchingMore,
    required this.hasReachedMax,
    required this.onRefresh,
    required this.onLoadMore,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: isLoading ? 10 : projects.length + (hasReachedMax ? 0 : 5),
        separatorBuilder: (context, index) => SizedBox(height: 6),
        itemBuilder: (context, index) {
          if (!isLoading &&
              !isFetchingMore &&
              !hasReachedMax &&
              index == projects.length + 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onLoadMore();
            });
          }
          if (index >= projects.length || isLoading) {
            return Skeletonizer(
              child: ProjectItemWidget(
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
                  isBookmark: false,
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
