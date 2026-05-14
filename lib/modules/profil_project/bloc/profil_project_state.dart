import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';

enum ProfilProjectStatus { initial, loading, success, error }

class ProfilProjectState extends Equatable {
  final List<ProjectEntity> allProjects;
  final List<ProjectEntity> takenProjects;
  final List<ProjectEntity> uploadedProjects;
  final bool isFetchingProjectAll;
  final bool isFetchingProjectTaken;
  final bool isFetchingProjectUploaded;

  final ProfilProjectStatus status;
  final String? message;

  final List<ProjectEntity> filteredCompletedProjects;
  final ProjectFilterType filterType;

  const ProfilProjectState({
    this.allProjects = const [],
    this.takenProjects = const [],
    this.uploadedProjects = const [],
    this.isFetchingProjectAll = false,
    this.isFetchingProjectTaken = false,
    this.isFetchingProjectUploaded = false,

    this.status = ProfilProjectStatus.initial,
    this.message,
    this.filterType = ProjectFilterType.all,
    this.filteredCompletedProjects = const [],
  });

  ProfilProjectState copyWith({
    final List<ProjectEntity>? allProjects,
    final List<ProjectEntity>? takenProjects,
    final List<ProjectEntity>? uploadedProjects,
    final bool? isFetchingProjectAll,
    final bool? isFetchingProjectTaken,
    final bool? isFetchingProjectUploaded,

    final ProfilProjectStatus? status,
    final String? message,
    final List<ProjectEntity>? filteredTakenProjects,
    final List<ProjectEntity>? filteredAllProjects,
    final ProjectFilterType? filterType,
    final List<ProjectEntity>? filteredCompletedProjects,
  }) {
    return ProfilProjectState(
      allProjects: allProjects ?? this.allProjects,
      takenProjects: takenProjects ?? this.takenProjects,
      uploadedProjects: uploadedProjects ?? this.uploadedProjects,
      isFetchingProjectAll:
          isFetchingProjectAll ?? this.isFetchingProjectAll,
      isFetchingProjectTaken:
          isFetchingProjectTaken ?? this.isFetchingProjectTaken,
      isFetchingProjectUploaded:
          isFetchingProjectUploaded ?? this.isFetchingProjectUploaded,
      status: status ?? this.status,
      message: message ?? this.message,
      filterType: filterType ?? this.filterType,
      filteredCompletedProjects: filteredCompletedProjects ?? this.filteredCompletedProjects,
    );
  }

  @override
  List<Object?> get props => [
    allProjects,
    takenProjects,
    uploadedProjects,
    isFetchingProjectTaken,
    isFetchingProjectUploaded,
    isFetchingProjectAll,
    status,
    message,
    filterType,
    filteredCompletedProjects,
  ];
}
