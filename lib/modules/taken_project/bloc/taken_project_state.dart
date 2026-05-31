import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';

enum TakenProjectStatus { initial, loading, success, error }

class TakenProjectState extends Equatable {
  final List<ProjectEntity> pendingProjects;
  final List<ProjectEntity> acceptedProjects;
  final List<ProjectEntity> rejectedProjects;

  final bool isFetchingPendingProjects;
  final bool isFetchingAcceptedProjects;
  final bool isFetchingRejectedProjects;

  final TakenProjectStatus status;
  final String? message;

  final List<ProjectEntity> filteredPendingProjects;
  final List<ProjectEntity> filteredAcceptedProjects;
  final List<ProjectEntity> filteredRejectedProjects;
  final ProjectFilterType filterType;

  const TakenProjectState({
    this.pendingProjects = const [],
    this.acceptedProjects = const [],
    this.rejectedProjects = const [],

    this.isFetchingPendingProjects = false,
    this.isFetchingAcceptedProjects = false,
    this.isFetchingRejectedProjects = false,

    this.status = TakenProjectStatus.initial,
    this.message,

    this.filteredPendingProjects = const [],
    this.filteredAcceptedProjects = const [],
    this.filteredRejectedProjects = const [],
    this.filterType = ProjectFilterType.all,
  });

  TakenProjectState copyWith({
    final List<ProjectEntity>? pendingProjects,
    final List<ProjectEntity>? acceptedProjects,
    final List<ProjectEntity>? rejectedProjects,
    final bool? isFetchingPendingProjects,
    final bool? isFetchingAcceptedProjects,
    final bool? isFetchingRejectedProjects,

    final TakenProjectStatus? status,
    final String? message,

    final List<ProjectEntity>? filteredPendingProjects,
    final List<ProjectEntity>? filteredAcceptedProjects,
    final List<ProjectEntity>? filteredRejectedProjects,
    final ProjectFilterType? filterType,
  }) {
    return TakenProjectState(
      pendingProjects: pendingProjects ?? this.pendingProjects,
      acceptedProjects: acceptedProjects ?? this.acceptedProjects,
      rejectedProjects: rejectedProjects ?? this.rejectedProjects,
      isFetchingPendingProjects:
          isFetchingPendingProjects ?? this.isFetchingPendingProjects,
      isFetchingAcceptedProjects:
          isFetchingAcceptedProjects ?? this.isFetchingAcceptedProjects,
      isFetchingRejectedProjects:
          isFetchingRejectedProjects ?? this.isFetchingRejectedProjects,
      status: status ?? this.status,
      message: message ?? this.message,

      filteredPendingProjects:
          filteredPendingProjects ?? this.filteredPendingProjects,
      filteredAcceptedProjects:
          filteredAcceptedProjects ?? this.filteredAcceptedProjects,
      filteredRejectedProjects:
          filteredRejectedProjects ?? this.filteredRejectedProjects,
      filterType: filterType ?? this.filterType,
    );
  }

  @override
  List<Object?> get props => [
    pendingProjects,
    acceptedProjects,
    rejectedProjects,
    isFetchingPendingProjects,
    isFetchingAcceptedProjects,
    isFetchingRejectedProjects,
    status,
    message,
    filterType,
    filteredPendingProjects,
    filteredAcceptedProjects,
    filteredRejectedProjects,
  ];
}
