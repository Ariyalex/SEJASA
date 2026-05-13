import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/project_entity.dart';

enum ProjectDetailStatus { initial, loading, success, error }

class ProjectDetailState extends Equatable {
  final ProjectEntity? project;
  final ProjectDetailStatus status;
  final String? message;

  const ProjectDetailState({
    this.project,
    this.status = ProjectDetailStatus.initial,
    this.message,
  });

  ProjectDetailState copyWith({
    final ProjectEntity? project,
    final ProjectDetailStatus? status,
    final String? message,
  }) {
    return ProjectDetailState(
      project: project ?? this.project,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [project, status, message];
}
