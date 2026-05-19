import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/project_category_entity.dart';

enum ProjectFormStatus { initial, loading, success, error }

class ProjectFormState extends Equatable {
  final ProjectFormStatus status;
  final List<ProjectCategoryEntity> projectCategories;
  final String? message;
  const ProjectFormState({
    this.status = ProjectFormStatus.initial,
    this.projectCategories = const [],
    this.message,
  });

  ProjectFormState copyWith({
    final ProjectFormStatus? status,
    final List<ProjectCategoryEntity>? projectCategories,
    final String? message,
  }) {
    return ProjectFormState(
      status: status ?? this.status,
      projectCategories: projectCategories ?? this.projectCategories,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
