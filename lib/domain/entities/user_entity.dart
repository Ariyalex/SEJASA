import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/skill_entity.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final GenderType gender;
  final double rating;
  final String? description;
  final String? contact;
  final String? address;
  final double longitude;
  final double latitude;
  final String? profilePicture;
  final List<SkillEntity>? skills;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.rating,
    this.description,
    this.contact,
    this.address,
    required this.latitude,
    required this.longitude,

    this.profilePicture,

    this.skills,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    gender,
    description,
    contact,
    longitude,
    latitude,
    rating,
    address,
    profilePicture,
    skills,
  ];
}
