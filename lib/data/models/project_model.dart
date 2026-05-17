import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.status,
    required super.distance,
    super.detailAddress,
    required super.category,
    super.description,
    super.requirements,
    super.hastags,
    required super.ownerName,
    required super.ownerRating,
    super.ownerImagePath,
    required super.ownerId,
    required super.maxParticipant,
    required super.currentParticipant,
    required super.latitude,
    required super.longitude,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      detailAddress: json['address'],
      status: ProjectStatus.stringToEnum(json['status']),
      distance: json['distance'],
      maxParticipant: json['max_participant'],
      currentParticipant: json['cur_participant'],
      category: json['category_name'],
      ownerName: json['owner_name'],
      ownerRating: json['owner_rating'],
      ownerImagePath: json['owner_iamge'],
      description: json['descriptions'],
      hastags: json['hastags'],
      requirements: json['requirements'],
      ownerId: json['user_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      name: name,
      description: description,
      hastags: hastags,
      requirements: requirements,
      currentParticipant: currentParticipant,
      maxParticipant: maxParticipant,
      status: status,
      distance: distance,
      detailAddress: detailAddress,
      ownerId: ownerId,
      latitude: latitude,
      longitude: longitude,
      category: category,
      ownerName: ownerName,
      ownerRating: ownerRating,
      ownerImagePath: ownerImagePath,
    );
  }
}
