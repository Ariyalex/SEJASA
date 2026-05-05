import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sejasa/core/widgets/my_chip.dart';
import 'package:sejasa/data/entities/project.dart';

class ProjectItemWidget extends StatelessWidget {
  final Project project;
  final int tipe;
  const ProjectItemWidget({super.key, required this.project, this.tipe = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (tipe == 0) {
      return tipe0(theme);
    } else if (tipe == 1) {
      return tipe1(theme);
    } else {
      return tipe0(theme);
    }
  }

  Widget tipe0(ThemeData theme) {
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

  Widget tipe1(ThemeData theme) {
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
              MyChip(title: project.status.display),
              MyChip(title: project.category),
              ...project.hastags?.map<Widget>((e) => MyChip(title: e)) ?? [],
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
