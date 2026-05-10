import 'package:equatable/equatable.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';

enum ProjectBlocStatus { initial, loading, success, error }

class ProjectState extends Equatable {
  final List<Project> takenProjects;
  final List<Project> uploadedProjects;
  final bool isFetchingProjectTaken;
  final bool isFetchingProjectUploaded;

  final ProjectBlocStatus status;
  final String? message;

  final List<Project> filteredTakenProjects;
  final List<Project> filteredUploadedProjects;
  final ProjectFilterType filterType;

  const ProjectState({
    this.takenProjects = const [],
    this.uploadedProjects = const [],
    this.isFetchingProjectTaken = false,
    this.isFetchingProjectUploaded = false,

    this.status = ProjectBlocStatus.initial,
    this.message,

    this.filteredTakenProjects = const [],
    this.filteredUploadedProjects = const [],
    this.filterType = ProjectFilterType.all,
  });

  ProjectState copyWith({
    final List<Project>? takenProjects,
    final List<Project>? uploadedProjects,
    final bool? isFetchingProjectTaken,
    final bool? isFetchingProjectUploaded,

    final ProjectBlocStatus? status,
    final String? message,

    final List<Project>? filteredTakenProjects,
    final List<Project>? filteredUploadedProjects,
    final ProjectFilterType? filterType,
  }) {
    return ProjectState(
      takenProjects: takenProjects ?? this.takenProjects,
      uploadedProjects: uploadedProjects ?? this.uploadedProjects,
      isFetchingProjectTaken:
          isFetchingProjectTaken ?? this.isFetchingProjectTaken,
      isFetchingProjectUploaded:
          isFetchingProjectUploaded ?? this.isFetchingProjectUploaded,
      status: status ?? this.status,
      message: message ?? this.message,

      filteredTakenProjects:
          filteredTakenProjects ?? this.filteredTakenProjects,
      filteredUploadedProjects:
          filteredUploadedProjects ?? this.filteredUploadedProjects,
      filterType: filterType ?? this.filterType,
    );
  }

  @override
  List<Object?> get props => [
    takenProjects,
    uploadedProjects,
    isFetchingProjectTaken,
    isFetchingProjectUploaded,
    status,
    message,
    filterType,
  ];
}
