import 'package:equatable/equatable.dart';
import 'package:sejasa/data/entities/project.dart';

class DashboardProjectTabPagingState extends Equatable {
  final List<Project> projects;
  final int currentPage;
  final bool isFetchingMore;
  final bool hasReachedMax;
  final bool isFetchingInitial;

  const DashboardProjectTabPagingState({
    this.projects = const [],
    this.currentPage = 1,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
    this.isFetchingInitial = false,
  });

  DashboardProjectTabPagingState copyWith({
    final List<Project>? projects,
    final int? currentPage,
    final bool? isFetchingMore,
    final bool? hasReachedMax,
    final bool? isFetchingInitial,
  }) {
    return DashboardProjectTabPagingState(
      projects: projects ?? this.projects,
      currentPage: currentPage ?? this.currentPage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingInitial: isFetchingInitial ?? this.isFetchingInitial,
    );
  }

  @override
  List<Object?> get props => [
    projects,
    currentPage,
    isFetchingMore,
    hasReachedMax,
    isFetchingInitial,
  ];
}
