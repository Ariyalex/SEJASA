import 'package:equatable/equatable.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';

enum MyProjectStatus { initial, loading, success, error }

class MyProjectState extends Equatable {
  final List<Project> takenProjects;
  final List<Project> uploadedProjects;
  final bool isFetchingProjectTaken;
  final bool isFetchingProjectUploaded;

  final MyProjectStatus status;
  final String? message;

  final List<Project> filteredTakenProjects;
  final List<Project> filteredUploadedProjects;
  final ProjectFilterType filterType;

  const MyProjectState({
    this.takenProjects = const [],
    this.uploadedProjects = const [],
    this.isFetchingProjectTaken = false,
    this.isFetchingProjectUploaded = false,

    this.status = MyProjectStatus.initial,
    this.message,

    this.filteredTakenProjects = const [],
    this.filteredUploadedProjects = const [],
    this.filterType = ProjectFilterType.all,
  });

  MyProjectState copyWith({
    final List<Project>? takenProjects,
    final List<Project>? uploadedProjects,
    final bool? isFetchingProjectTaken,
    final bool? isFetchingProjectUploaded,

    final MyProjectStatus? status,
    final String? message,

    final List<Project>? filteredTakenProjects,
    final List<Project>? filteredUploadedProjects,
    final ProjectFilterType? filterType,
  }) {
    return MyProjectState(
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
    filteredTakenProjects,
    filteredUploadedProjects,
  ];
}
