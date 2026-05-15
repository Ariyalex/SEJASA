import 'package:sejasa/data/models/skill_model.dart';
import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.gender,
    required super.rating,
    super.description,
    super.contact,
    super.address,
    required super.latitude,
    required super.longitude,
    super.profilePicture,
    super.skills,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: GenderType.values.firstWhere(
        (e) => e.jsonValue == json['gender'],
        orElse: () => GenderType.male,
      ),
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String?,
      contact: json['contact'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      profilePicture: json['image'] as String?,
      skills: (json['skills'] as List?)
          ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender.jsonValue,
      'rating': rating,
      'description': description,
      'contact': contact,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'profile_picture': profilePicture,
      'skills': skills
          ?.map(
            (e) => SkillModel(
              id: e.id,
              name: e.name,
              description: e.description,
            ).toJson(),
          )
          .toList(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      gender: gender,
      rating: rating,
      description: description,
      contact: contact,
      address: address,
      latitude: latitude,
      longitude: longitude,
      profilePicture: profilePicture,
      skills: skills,
    );
  }
}
