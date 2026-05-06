import 'package:equatable/equatable.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_tab_paging_state.dart';

enum DashboardProjectStatus { initial, loading, success, error }

class DashboardProjectState extends Equatable {
  final DashboardProjectTabPagingState closest;
  final DashboardProjectTabPagingState latest;
  final DashboardProjectTabPagingState popular;

  final DashboardProjectStatus status;
  final String? message;

  const DashboardProjectState({
    this.closest = const DashboardProjectTabPagingState(),
    this.latest = const DashboardProjectTabPagingState(),
    this.popular = const DashboardProjectTabPagingState(),

    this.status = DashboardProjectStatus.initial,
    this.message,
  });

  DashboardProjectState copyWith({
    final DashboardProjectTabPagingState? closest,
    final DashboardProjectTabPagingState? latest,
    final DashboardProjectTabPagingState? popular,
    final DashboardProjectStatus? status,
    final String? message,
  }) {
    return DashboardProjectState(
      closest: closest ?? this.closest,
      latest: latest ?? this.latest,
      popular: popular ?? this.popular,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [closest, latest, popular, status, message];
}
