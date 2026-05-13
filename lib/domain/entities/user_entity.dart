import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final double rating;
  final String address;
  final String? profilePicture;
  final String gender;
  final int totalProjectsCreated;
  final int totalProjectsCompleted;
  final List<String> skills;

  const UserEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.address,
    this.profilePicture,
    required this.gender,
    required this.totalProjectsCreated,
    required this.totalProjectsCompleted,
    required this.skills,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        address,
        profilePicture,
        gender,
        totalProjectsCreated,
        totalProjectsCompleted,
        skills,
      ];
}
