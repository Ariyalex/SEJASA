import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/domain/entities/project_entity.dart';

class ProjectInfoCard extends HookWidget {
  final ProjectEntity project;
  final bool isSkeleton;
  const ProjectInfoCard({
    super.key,
    required this.project,
    this.isSkeleton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locationService = context.read<LocationService>();

    String projcetAddress = "";
    useEffect(() {
      if (project.detailAddress == null && !isSkeleton) {
        locationService
            .getAddressFromLatLng(LatLng(project.latitude, project.longitude))
            .then((value) {
              projcetAddress = value;
            });
      }
      return null;
    }, [project]);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  project.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${project.currentParticipant}/${project.maxParticipant} Pelamar",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  project.detailAddress ?? projcetAddress,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.route_outlined, size: 18, color: colorScheme.primary),
              if (project.distance != null) ...[
                const SizedBox(width: 4),
                Text(
                  "${round(project.distance! / 1000, decimals: 2)} KM",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
          Row(
            spacing: 6,
            children: [
              MyVisualChip(
                title: project.status.display,
                textColor: project.status.getTextColor(theme),
                backgroundColor: project.status.getBackgroundColor(theme),
              ),
              MyVisualChip(
                title: project.category.name,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                textColor: colorScheme.primary,
              ),
            ],
          ),
          if (project.hastags != null && project.hastags!.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: project.hastags!
                  .map<Widget>((e) => MyVisualChip(title: "#$e"))
                  .toList(),
            ),
          const Divider(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.ownerName,
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        RatingBarIndicator(
                          itemBuilder: (context, index) {
                            return const Icon(Icons.star, color: Colors.amber);
                          },
                          itemCount: 5,
                          rating: project.ownerRating,
                          itemSize: 14,
                        ),
                        Text(
                          project.ownerRating.toStringAsFixed(2),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  context.pushNamed(
                    RouteNamed.projectDetail,
                    pathParameters: {'id': project.id},
                    extra: {'is_owner': false, 'read_more': true},
                  );
                },
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Selengkapnya'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
