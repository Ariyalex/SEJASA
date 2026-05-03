import 'package:flutter/material.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/modules/dashboard/widgets/project_item_widget.dart';

class BuildProjectListWidget extends StatelessWidget {
  const BuildProjectListWidget({super.key, required this.theme});

  final ThemeData theme;

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
          return Column(children: [ProjectItemWidget(theme: theme)]);
        },
      ),
    );
  }
}
