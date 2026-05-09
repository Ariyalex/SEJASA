import 'package:equatable/equatable.dart';
import 'package:sejasa/data/entities/project.dart';

enum ProjectBlocStatus { initial, loading, success, error }

class ProjectState extends Equatable {
  final List<Project> projectsTaken;
  final List<Project> projectsUploaded;

  final ProjectBlocStatus status;
  final String? message;

  const ProjectState({
    this.projectsTaken = const [],
    this.projectsUploaded = const [],
    this.status = ProjectBlocStatus.initial,
    this.message,
  });

  ProjectState copyWith({
    final List<Project>? projectsTaken,
    final List<Project>? projectsUploaded,

    final ProjectBlocStatus? status,
    final String? message,
  }) {
    return ProjectState(
      projectsTaken: projectsTaken ?? this.projectsTaken,
      projectsUploaded: projectsUploaded ?? this.projectsUploaded,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [projectsTaken, projectsUploaded, status, message];
}
