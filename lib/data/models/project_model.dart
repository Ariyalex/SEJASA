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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      detailAddress: json['address'],
      status: ProjectStatus.stringToEnum(json['status'] ?? 'hiring'),
      distance: (json['distance_meters'] as num?)?.toDouble() ?? 0.0,
      maxParticipant: json['max_participant'] ?? 0,
      currentParticipant: json['cur_participant'] ?? 0,
      category: json['category_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerRating: (json['owner_rating'] as num?)?.toDouble() ?? 0.0,
      ownerImagePath: json['owner_image'],
      description: json['descriptions'] is String 
          ? json['descriptions'] 
          : null, // Handle potential JSON object/string variance
      hastags: (json['hastags'] as List?)?.map((e) => e.toString()).toList(),
      requirements: (json['requirements'] as List?)?.map((e) => e.toString()).toList(),
      ownerId: json['user_id'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
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
