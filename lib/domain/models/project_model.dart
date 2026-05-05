import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/value_objects/project_status.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.address,
    required super.status,
    required super.distance,
    required super.participant,
    required super.category,
    super.description,
    super.requirements,
    super.hastags,
    required super.ownerName,
    required super.ownerRating,
    super.ownerImagePath,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      status: ProjectStatus.stringToEnum(json['status']),
      distance: json['distance'],
      participant: json['participant'],
      category: json['category'],
      ownerName: json['owner'],
      ownerRating: json['owner_rating'],
      ownerImagePath: json['owner_iamge'],
      description: json['description'],
      hastags: json['hastags'],
      requirements: json['requirements'],
    );
  }

  Project toEntity() {
    return Project(
      id: id,
      title: title,
      description: description,
      hastags: hastags,
      requirements: requirements,
      address: address,
      status: status,
      distance: distance,
      participant: participant,
      category: category,
      ownerName: ownerName,
      ownerRating: ownerRating,
      ownerImagePath: ownerImagePath,
    );
  }
}
