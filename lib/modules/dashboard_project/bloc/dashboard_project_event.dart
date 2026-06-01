import 'package:equatable/equatable.dart';

enum DashboardProjectTabType { latest, closest, popular }

class DashboardProjectEvent extends Equatable {
  const DashboardProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialProjectsEvent extends DashboardProjectEvent {
  final DashboardProjectTabType tabType;
  final double? latitude;
  final double? longitude;
  const LoadInitialProjectsEvent({
    required this.tabType,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [tabType, latitude, longitude];
}

class LoadMoreProjectsEvent extends DashboardProjectEvent {
  final DashboardProjectTabType tabType;
  final double? latitude;
  final double? longitude;
  const LoadMoreProjectsEvent({
    required this.tabType,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [tabType, latitude, longitude];
}

class UpdateDashboardLocationEvent extends DashboardProjectEvent {
  final double latitude;
  final double longitude;
  final String address;

  const UpdateDashboardLocationEvent({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}
