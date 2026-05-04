import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sejasa/core/widgets/my_chip.dart';
import 'package:sejasa/data/entities/project.dart';

class ProjectItemWidget extends StatelessWidget {
  final Project project;
  const ProjectItemWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            spacing: 6,
            children: [
              RatingBarIndicator(
                itemBuilder: (context, index) {
                  return Icon(Icons.star, color: Colors.amber);
                },
                itemCount: 5,

                rating: project.ownerRating,
                itemSize: 24,
              ),
              Text("4.6"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  spacing: 4,
                  children: [
                    Icon(Icons.person),
                    Expanded(
                      child: Text(
                        project.ownerName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(project.address, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              MyChip(title: project.status.display),
              MyChip(title: project.category),
              ...project.hastags?.map<Widget>((e) => MyChip(title: e)) ?? [],
            ],
          ),
        ],
      ),
      onTap: () {},
      tileColor: theme.scaffoldBackgroundColor,
    );
  }
}
