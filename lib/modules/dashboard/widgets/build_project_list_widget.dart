import 'package:flutter/material.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/modules/dashboard/widgets/project_item_widget.dart';

class BuildProjectListWidget extends StatelessWidget {
  final List<Project> projects;
  final int tipe;
  const BuildProjectListWidget({
    super.key,
    required this.projects,
    this.tipe = 0,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        LogUtils.d("belum ada apa apa");
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 6),
        itemCount: 20,
        separatorBuilder: (context, index) => SizedBox(height: 6),
        itemBuilder: (context, index) {
          return Column(
            children: [ProjectItemWidget(project: projects[0], tipe: tipe)],
          );
        },
      ),
    );
  }
}
