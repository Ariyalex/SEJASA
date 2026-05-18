import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/widgets/project_item_widget.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuildProjectListWidget extends StatelessWidget {
  final RefreshCallback onRefresh;
  final List<ProjectEntity> projects;
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
                    "Belum ada proyek",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Refresh halaman untuk mencoba lagi",
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
        itemCount: isLoading ? 5 : projects.length,
        separatorBuilder: (context, index) => SizedBox(height: 6),
        itemBuilder: (context, index) {
          if (isLoading) {
            return Skeletonizer(
              child: ProjectItemWidget(
                isMyProject: isMyProjects,
                project: ProjectEntity.dummyProject(),
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
