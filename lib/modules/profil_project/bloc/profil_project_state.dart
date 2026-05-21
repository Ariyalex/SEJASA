import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';

enum ProfilProjectStatus { initial, loading, success, error }

class ProfilProjectState extends Equatable {
  final List<ProjectEntity> uploadedProjects;
  final bool isFetchingProjectUploaded;

  final List<ProjectEntity> takenProjects;
  final bool isFetchingProjectTaken;

  final ProfilProjectStatus status;
  final String? message;

  final List<ProjectEntity> filteredUploadedProjects;
  final ProjectFilterType filterType;

  const ProfilProjectState({
    this.uploadedProjects = const [],
    this.isFetchingProjectUploaded = false,
    this.takenProjects = const [],
    this.isFetchingProjectTaken = false,
    this.status = ProfilProjectStatus.initial,
    this.message,
    this.filterType = ProjectFilterType.all,
    this.filteredUploadedProjects = const [],
  });

  ProfilProjectState copyWith({
    final List<ProjectEntity>? uploadedProjects,
    final bool? isFetchingProjectUploaded,
    final List<ProjectEntity>? takenProjects,
    final bool? isFetchingProjectTaken,
    final ProfilProjectStatus? status,
    final String? message,
    final ProjectFilterType? filterType,
    final List<ProjectEntity>? filteredUploadedProjects,
  }) {
    return ProfilProjectState(
      uploadedProjects: uploadedProjects ?? this.uploadedProjects,
      isFetchingProjectUploaded:
          isFetchingProjectUploaded ?? this.isFetchingProjectUploaded,
      takenProjects: takenProjects ?? this.takenProjects,
      isFetchingProjectTaken:
          isFetchingProjectTaken ?? this.isFetchingProjectTaken,
      status: status ?? this.status,
      message: message ?? this.message,
      filterType: filterType ?? this.filterType,
      filteredUploadedProjects:
          filteredUploadedProjects ?? this.filteredUploadedProjects,
    );
  }

  @override
  List<Object?> get props => [
    uploadedProjects,
    isFetchingProjectUploaded,
    takenProjects,
    isFetchingProjectTaken,
    status,
    message,
    filterType,
    filteredUploadedProjects,
  ];
}
