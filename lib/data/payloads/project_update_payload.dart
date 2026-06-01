class ProjectUpdatePayload {
  final String id;
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

  ProjectUpdatePayload({
    required this.id,
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
    final Map<String, dynamic> data = {
      "name": name,
      "address": address,
      "status": status,
      "max_participant": maxParticipant,
      "descriptions": descriptions,
      // Mapping list of object menjadi list of map
      "requirements": requirements,
      "latitude": latitude,
      "longitude": longitude,
      // Typo dari backend tetap kita ikuti "hastags" agar API tidak error
      "hastags": hastags,
      "category_id": categoryId,
    };
    return data;
  }
}
