import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sejasa/core/widgets/my_chip.dart';

class ProjectItemWidget extends StatelessWidget {
  const ProjectItemWidget({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Nama project", style: theme.textTheme.titleMedium),
          Text(
            "6 / 7 pelamar",
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

                rating: 4.6,
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
                        "joko anwar al mansur bin sigma",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(
                  "Sleman, DI Yogyakarta",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              MyChip(theme: theme),
              MyChip(theme: theme),
              MyChip(theme: theme),
              MyChip(theme: theme),
              MyChip(theme: theme),
              MyChip(theme: theme),
              MyChip(theme: theme),
            ],
          ),
        ],
      ),
      onTap: () {},
      tileColor: theme.scaffoldBackgroundColor,
    );
  }
}
