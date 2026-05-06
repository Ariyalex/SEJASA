import 'package:equatable/equatable.dart';

enum DashboardProjectTabType { latest, closest, popular }

class DashboardProjectEvent extends Equatable {
  const DashboardProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialProjectsEvent extends DashboardProjectEvent {
  final DashboardProjectTabType tabType;
  const LoadInitialProjectsEvent(this.tabType);

  @override
  List<Object?> get props => [tabType];
}

class LoadMoreProjectsEvent extends DashboardProjectEvent {
  final DashboardProjectTabType tabType;
  const LoadMoreProjectsEvent(this.tabType);

  @override
  List<Object?> get props => [tabType];
}
