import 'package:equatable/equatable.dart';

class ProjectCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String? description;

  const ProjectCategoryEntity({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];

  ProjectCategoryEntity copyWith({
    final String? name,
    final String? description,
  }) {
    return ProjectCategoryEntity(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
