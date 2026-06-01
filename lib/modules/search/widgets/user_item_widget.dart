import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sejasa/core/config/app_config.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/domain/entities/user_entity.dart';

class UserItemWidget extends StatelessWidget {
  final UserEntity user;
  const UserItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Modern profile image network binding or fallback
    final hasImage = user.profilePicture != null && user.profilePicture!.isNotEmpty;
    final ImageProvider? profileImage = hasImage
        ? NetworkImage(AppConfig.baseApiUrl + user.profilePicture!)
        : null;

    // Filter to top 3 skills to avoid overcrowding the card
    final displayedSkills = user.skills != null
        ? user.skills!.take(3).toList()
        : const [];

    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      color: theme.cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(
          RouteNamed.userProfile,
          pathParameters: {'id': user.id},
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    backgroundImage: profileImage,
                    child: profileImage == null
                        ? Icon(
                            Icons.person,
                            size: 26.r,
                            color: theme.colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user.address != null && user.address!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 12.r,
                                color: theme.hintColor,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  user.address!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.hintColor,
                                    fontSize: 11.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Premium amber rating badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 14.r,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          user.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.amber[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (user.description != null && user.description!.trim().isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(
                  user.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (displayedSkills.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: displayedSkills.map((skill) {
                    return MyVisualChip(
                      title: skill.name,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                      textColor: theme.colorScheme.primary,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
