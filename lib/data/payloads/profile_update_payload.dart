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
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (description != null) 'descriptions': description,
      if (contact != null) 'contact': contact,
      if (gender != null) 'gender': gender,
      if (detailAddress != null) 'address': detailAddress,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (imagePath != null) 'image': imagePath,
    };
  }
}
