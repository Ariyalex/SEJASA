import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/config/app_config.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';

class UserProfileHeaderWidget extends HookWidget {
  final UserEntity user;

  const UserProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final locationService = getIt<LocationService>();
    final address = useState<String>('');
    useEffect(() {
      if (user.address == null) {
        locationService
            .getAddressFromLatLng(LatLng(user.latitude, user.longitude))
            .then((value) {
              address.value = value;
            });
      } else {
        address.value = user.address!;
      }
      return null;
    }, [user]);

    // final photoProfile = useMemoized<ImageProvider?>(() {
    //   if (user.profilePicture != null) {
    //     return NetworkImage(AppConfig.baseUrl + user.profilePicture!);
    //   } else {
    //     return null;
    //   }
    // }, []);

    final photoProfile = useState<ImageProvider?>(null);
    useEffect(() {
      if (user.profilePicture != null) {
        photoProfile.value = NetworkImage(
          AppConfig.baseUrl + user.profilePicture!,
        );
      }
      return null;
    }, [user]);

    LogUtils.d("user skill: ${user.skills?.length}");

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFFD9D9D9),
                      backgroundImage: photoProfile.value,
                      child: Icon(Icons.person, color: Colors.white, size: 45),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),

                              if (user.gender == GenderType.male)
                                const Icon(
                                  LucideIcons.mars,
                                  size: 16,
                                  color: Colors.blue,
                                )
                              else if (user.gender == GenderType.female)
                                const Icon(
                                  LucideIcons.venus,
                                  size: 16,
                                  color: Colors.pink,
                                )
                              else
                                const Icon(
                                  LucideIcons.user,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            // "$completedProjects diselesaikan - $createdProjects dibuat",
                            "67 diselesaikan - 67 dibuat",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            spacing: 6,
                            children: [
                              RatingBarIndicator(
                                itemBuilder: (context, index) {
                                  return Icon(Icons.star, color: Colors.amber);
                                },
                                itemCount: 5,
                                rating: user.rating,
                                itemSize: 20,
                              ),
                              Text(
                                user.rating.toString(),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                        address.value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Bagian 2: Deskripsi / Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              user.description ?? "User malas mengisi bio....",
              style: const TextStyle(fontSize: 14),
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Keahlian",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (user.skills == null || user.skills!.isEmpty)
                      Text("User sangat malas hingga tidak punya skill...")
                    else
                      ...user.skills!.map(
                        (skill) => MyVisualChip(
                          title: skill.name,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          textColor: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Info Kontak",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (user.contact != null)
                  Row(
                    children: [
                      Icon(
                        LucideIcons.phone,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(user.contact!),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      LucideIcons.mail,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(user.email),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
