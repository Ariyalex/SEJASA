import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/domain/entities/user_entity.dart';

class UserItemWidget extends StatelessWidget {
  final UserEntity user;
  const UserItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            backgroundImage: user.profilePicture != null ? NetworkImage(user.profilePicture!) : null,
            child: user.profilePicture == null ? Icon(Icons.person, size: 30, color: theme.colorScheme.onSurfaceVariant) : null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  user.name,
                  style: theme.textTheme.titleMedium,
                ),
                Row(
                  spacing: 6,
                  children: [
                    RatingBarIndicator(
                      itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      rating: user.rating,
                      itemSize: 18,
                    ),
                    Text(
                      user.rating.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(
                  user.gender,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: user.skills.map((skill) => MyVisualChip(title: skill)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
