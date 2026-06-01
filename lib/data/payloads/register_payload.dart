class RegisterPayload {
  final String name;
  final String email;
  final String password1;
  final String password2;
  final String? gender;
  final String accountType;
  final double latitude;
  final double longitude;

  RegisterPayload({
    required this.name,
    required this.email,
    required this.password1,
    required this.password2,
    this.gender,
    required this.latitude,
    required this.longitude,
    required this.accountType,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password1': password1,
      'password2': password2,
      if (gender != null && gender!.isNotEmpty) 'gender': gender,
      'account_type': accountType,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
