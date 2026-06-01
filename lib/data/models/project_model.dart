import 'package:sejasa/data/models/project_category_model.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.status,
    required super.projectRating,
    super.distance,
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
    super.currentParticipant,
    required super.acceptedParticipant,
    required super.latitude,
    required super.longitude,
    super.chatId,
    super.givenRating,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: ProjectStatus.stringToEnum(json['status'] ?? 'hiring'),
      description: json['descriptions'] is String
          ? json['descriptions']
          : null, // Handle potential JSON object/string variance
      projectRating: json['rating'] ?? 0,
      detailAddress: json['address'],
      distance: (json['distance_meters'] as num?)?.toDouble(),
      maxParticipant: json['max_participant'] ?? 0,
      currentParticipant: json['cur_participant'] ?? 0,
      acceptedParticipant: json['cur_participant_accepted'] ?? 0,
      category: json['category'] != null
          ? ProjectCategoryModel.fromJson(json['category'])
          : ProjectCategoryModel(
              id: 0,
              name: json['category'] ?? json['category_name'],
            ),
      ownerName: json['owner']?['name'] ?? json['owner_name'] ?? '',
      ownerRating: (json['owner']?['rating'] as num?)?.toDouble() ?? 0.0,
      ownerImagePath: json['owner']?['image'] ?? json['owner_image'] ?? '',
      hastags: (json['hastags'] as List?)?.map((e) => e.toString()).toList(),
      requirements: (json['requirements'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      ownerId: json['owner']?['id'] ?? json['user_id'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      chatId: json['chat_id'] as String? ?? '',
      givenRating: json['rating_given'] as double? ?? 0,
    );
  }

  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      name: name,
      description: description,
      projectRating: projectRating,
      hastags: hastags,
      requirements: requirements,
      currentParticipant: currentParticipant,
      acceptedParticipant: acceptedParticipant,
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
      chatId: chatId,
      givenRating: givenRating,
    );
  }
}
