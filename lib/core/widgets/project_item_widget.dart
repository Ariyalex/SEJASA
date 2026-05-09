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
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${project.participant} Pelamar",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        project.address,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.route_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(project.distance),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  spacing: 6,
                  children: [
                    MyVisualChip(
                      title: project.status.display,
                      textColor: project.status.getTextColor(theme),
                      backgroundColor: project.status.getBackgroundColor(theme),
                    ),
                    MyVisualChip(
                      title: project.category,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      textColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      project.hastags
                          ?.map<Widget>((e) => MyVisualChip(title: "#$e"))
                          .toList() ??
                      [],
                ),
                if (!isMyProject) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1),
                  ),
                  _buildOwnerProfile(theme),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerProfile(ThemeData theme) {
    return Row(
      spacing: 10,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 18, color: Colors.white),
        ),
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
                Text(
                  project.ownerRating.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
