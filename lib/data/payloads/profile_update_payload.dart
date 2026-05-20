class UserUpdatePayload {
  final String? name;
  final String? email;
  final String? imagePath;
  final String? description;
  final String? gender;
  final String? detailAddress;
  final String? contact;
  final double? latitude;
  final double? longitude;

  UserUpdatePayload({
    this.name,
    this.email,
    this.imagePath,
    this.description,
    this.detailAddress,
    this.contact,
    this.gender,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'descriptions': description,
      'contact': contact,
      'gender': gender,
      'address': detailAddress,
      'latitude': latitude,
      'longitude': longitude,
      'image': imagePath,
    };
  }
}
