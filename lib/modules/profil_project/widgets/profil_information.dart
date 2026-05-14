import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String gender;
  final double rating;
  final int completedProjects;
  final int createdProjects;
  final String location;
  final String bio;
  final List<String> skills;
  final String phoneNumber;
  final String email;

  const UserProfileHeaderWidget({
    super.key,
    this.name = "Yuusha Himmel",
    this.gender = "laki-laki",
    this.rating = 4,
    this.completedProjects = 18,
    this.createdProjects = 18,
    this.location = "Benua Barat, Isekai",
    this.bio =
        "Si pria amal jariyah yang sampe meninggal gak menemukan my kisah.",
    this.skills = const ["berpedang", "gombal", "tampan"],
    this.phoneNumber = "0888888888",
    this.email = "yuusha.himmel@gmail.com",
  });

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFFD9D9D9),
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
                                  "fasdfdas fdsf dsa  ",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),

                              if (gender == "laki-laki")
                                const Icon(
                                  LucideIcons.mars,
                                  size: 16,
                                  color: Colors.blue,
                                )
                              else if (gender == "perempuan")
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
                            "$completedProjects diselesaikan - $createdProjects dibuat",
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
                                rating: rating,
                                itemSize: 20,
                              ),
                              Text(
                                rating.toString(),
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
                      child: Text(location, overflow: TextOverflow.ellipsis),
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
            child: Text(bio, style: const TextStyle(fontSize: 14)),
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
                  children: skills
                      .map(
                        (skill) => MyVisualChip(
                          title: skill,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          textColor: theme.colorScheme.primary,
                        ),
                      )
                      .toList(),
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
                Row(
                  children: [
                    Icon(
                      LucideIcons.phone,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(phoneNumber),
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
                    Text(email),
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
