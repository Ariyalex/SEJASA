import 'package:equatable/equatable.dart';
import 'package:sejasa/data/value_objects/project_status.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String address;
  final ProjectStatus status;
  final String distance;
  final String participant;
  final String category;
  final String? description;
  final List<String>? requirements;
  final List<String>? hastags;
  final String ownerName;
  final double ownerRating;
  final String? ownerImagePath;

  const Project({
    required this.id,
    required this.title,
    required this.address,
    required this.status,
    required this.distance,
    required this.participant,
    required this.category,
    this.description,
    this.requirements,
    this.hastags,
    required this.ownerName,
    required this.ownerRating,
    this.ownerImagePath,
  });

  Project copyWith({
    final String? title,
    final String? address,
    final ProjectStatus? status,
    final String? distance,
    final String? participant,
    final String? category,
    final String? description,
    final List<String>? requirements,
    final List<String>? hastags,
    final String? ownerName,
    final double? ownerRating,
    final String? ownerImagePath,
  }) {
    return Project(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      participant: participant ?? this.participant,
      category: category ?? this.category,
      hastags: hastags ?? this.hastags,
      requirements: requirements ?? this.requirements,
      ownerName: ownerName ?? this.ownerName,
      ownerRating: ownerRating ?? this.ownerRating,
      ownerImagePath: ownerImagePath ?? this.ownerImagePath,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    address,
    status,
    distance,
    participant,
    category,
    hastags,
    requirements,
    ownerName,
    ownerRating,
    ownerImagePath,
  ];
}
