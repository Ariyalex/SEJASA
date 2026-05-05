import 'package:equatable/equatable.dart';
import 'package:sejasa/data/entities/project.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState extends Equatable {
  final List<Project> projects;
  final DashboardStatus status;
  final String? message;

  const DashboardState({
    this.projects = const [],
    this.status = DashboardStatus.initial,
    this.message,
  });

  DashboardState copyWith({
    final List<Project>? projects,
    final DashboardStatus? status,
    final String? message,
  }) {
    return DashboardState(
      projects: projects ?? this.projects,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [projects, status, message];
}
