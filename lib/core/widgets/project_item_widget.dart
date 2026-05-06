import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/data/entities/project.dart';

class ProjectItemWidget extends StatelessWidget {
  final Project project;
  final bool isMyProject;
  const ProjectItemWidget({
    super.key,
    required this.project,
    this.isMyProject = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isMyProject) {
      return myProjectTile(theme);
    } else {
      return otherProjectTile(theme);
    }
  }

  Widget myProjectTile(ThemeData theme) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(project.title, style: theme.textTheme.titleMedium),
          Text(
            "${project.participant} pelamar",
            style: theme.textTheme.titleSmall!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      subtitle: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(project.address, overflow: TextOverflow.ellipsis),
              ),
              Text(project.distance),
            ],
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              MyVisualChip(title: project.status.display),
              MyVisualChip(title: project.category),
              ...project.hastags?.map<Widget>((e) => MyVisualChip(title: e)) ??
                  [],
            ],
          ),
        ],
      ),
      onTap: () {},
      tileColor: theme.scaffoldBackgroundColor,
    );
  }

  Widget otherProjectTile(ThemeData theme) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(project.title, style: theme.textTheme.titleMedium),
          Text(
            "${project.participant} pelamar",
            style: theme.textTheme.titleSmall!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      subtitle: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(project.address, overflow: TextOverflow.ellipsis),
              ),
              Text(project.distance),
            ],
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              MyVisualChip(title: project.status.display),
              MyVisualChip(title: project.category),
              ...project.hastags?.map<Widget>((e) => MyVisualChip(title: e)) ??
                  [],
            ],
          ),
          Row(
            spacing: 10,
            children: [
              CircleAvatar(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.ownerName,
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    spacing: 6,
                    children: [
                      RatingBarIndicator(
                        itemBuilder: (context, index) {
                          return Icon(Icons.star, color: Colors.amber);
                        },
                        itemCount: 5,

                        rating: project.ownerRating,
                        itemSize: 18,
                      ),
                      Text("4.6"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      onTap: () {},
      tileColor: theme.scaffoldBackgroundColor,
    );
  }
}
