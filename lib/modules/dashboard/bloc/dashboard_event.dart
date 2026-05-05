import 'package:equatable/equatable.dart';

enum ProjectsListCategory { latest, closest, popular }

class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjects extends DashboardEvent {
  final ProjectsListCategory category;
  const LoadProjects(this.category);

  @override
  List<Object?> get props => [category];
}
