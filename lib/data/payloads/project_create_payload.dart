// 1. Class kecil untuk menangani objek di dalam array requirements

// 2. Class utama untuk pengiriman data Project
import 'package:uuid/uuid.dart';

class ProjectCreatePayload {
  final String name;
  final String address;
  final String status;
  final int maxParticipant;
  final String descriptions;
  final List<String> requirements; // Menggunakan class yang dibuat di atas
  final double latitude;
  final double longitude;
  final int categoryId;
  final List<String>? hastags;

  ProjectCreatePayload({
    required this.name,
    required this.address,
    required this.status,
    required this.maxParticipant,
    required this.descriptions,
    required this.requirements,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
    required this.hastags,
  });

  // Fungsi utama untuk mengubah seluruh class menjadi format JSON yang siap dikirim
  Map<String, dynamic> toJson() {
    final payload = {
      "name": name,
      "address": address,
      "status": status,
      "max_participant": maxParticipant,
      "descriptions": descriptions,
      // Mapping list of object menjadi list of map
      "requirements": requirements,
      "slug": generateSlugWithUuid(name),
      "latitude": latitude,
      "longitude": longitude,
      // Typo dari backend tetap kita ikuti "hastags" agar API tidak error
      "hastags": hastags,
      "category_id": categoryId,
    };

    return payload;
  }

  static String generateSlugWithUuid(String title) {
    String cleanTitle = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');

    // Generate UUID v4, lalu ambil 6 karakter pertamanya saja agar URL tidak kepanjangan
    String shortUuid = const Uuid().v4().substring(0, 6);

    return '$cleanTitle-$shortUuid';
    // Hasil: mengalahkan-raja-iblis-f4a2b1
  }
}
