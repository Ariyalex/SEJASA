import 'package:sejasa/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.address,
    super.profilePicture,
    required super.gender,
    required super.totalProjectsCreated,
    required super.totalProjectsCompleted,
    required super.skills,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      address: json['address'] as String,
      profilePicture: json['profile_picture'] as String?,
      gender: json['gender'] as String,
      totalProjectsCreated: json['total_projects_created'] as int,
      totalProjectsCompleted: json['total_projects_completed'] as int,
      skills: List<String>.from(json['skills'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'address': address,
      'profile_picture': profilePicture,
      'gender': gender,
      'total_projects_created': totalProjectsCreated,
      'total_projects_completed': totalProjectsCompleted,
      'skills': skills,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      rating: rating,
      address: address,
      profilePicture: profilePicture,
      gender: gender,
      totalProjectsCreated: totalProjectsCreated,
      totalProjectsCompleted: totalProjectsCompleted,
      skills: skills,
    );
  }
}
