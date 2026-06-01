import 'package:sejasa/domain/entities/project_category_entity.dart';

class ProjectCategoryModel extends ProjectCategoryEntity {
  const ProjectCategoryModel({
    required super.id,
    required super.name,
    super.description,
  });

  factory ProjectCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProjectCategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['descriptions'],
    );
  }

  ProjectCategoryEntity toEntity() {
    return ProjectCategoryEntity(id: id, name: name, description: description);
  }
}
