import 'package:sejasa/domain/entities/skill_entity.dart';

class SkillModel extends SkillEntity {
  const SkillModel({required super.id, required super.name, super.description});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  SkillEntity toEntity() {
    return SkillEntity(id: id, name: name, description: description);
  }
}
