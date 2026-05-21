import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/widgets/project_item_widget.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuildProjectListFetchPageWidget extends HookWidget {
  final List<ProjectEntity> projects;
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
    if (!isLoading && projects.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.folderOpen,
                    size: 64,
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Proyek tidak ditemukan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Coba cari dengan kata kunci lain atau refresh halaman",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

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
              child: ProjectItemWidget(project: ProjectEntity.dummyProject()),
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
