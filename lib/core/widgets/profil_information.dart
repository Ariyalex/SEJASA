import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    this.bio = "Si pria amal jariyah yang sampe meninggal gak menemukan my kisah.",
    this.skills = const ["berpedang", "gombal", "tampan"],
    this.phoneNumber = "0888888888",
    this.email = "yuusha.himmel@gmail.com",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, thickness: 1, color: Colors.black87),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (gender == "laki-laki")
                              const Icon(LucideIcons.mars, size: 16, color: Colors.blue)
                            else if (gender == "perempuan")
                              const Icon(LucideIcons.venus, size: 16, color: Colors.pink)
                            else
                              const Icon(LucideIcons.user, size: 16, color: Colors.grey),
                          ],
                        ),
                        // Rating
                        Row(
                          children: [
                            Row(
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, index) {
                                    return Icon(Icons.star, color: Colors.amber);
                                  },
                                  itemCount: 5,
                                  rating: rating,
                                  itemSize: 14,
                                ),
                                Text(
                                  rating.toString(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$completedProjects diselesaikan - $createdProjects dibuat",
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Colors.black87),

        // Bagian 2: Deskripsi / Bio
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            bio,
            style: const TextStyle(fontSize: 14),
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Colors.black87),

        Padding(
          padding: const EdgeInsets.all(16.0),
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
                children: skills.map((skill) => _buildChip(skill)).toList(),
              ),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Colors.black87),

        Padding(
          padding: const EdgeInsets.all(16.0),
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
                  const Icon(LucideIcons.phone, size: 18),
                  const SizedBox(width: 8),
                  Text(phoneNumber),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(LucideIcons.mail, size: 18),
                  const SizedBox(width: 8),
                  Text(email),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Colors.black87),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFC6D8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}