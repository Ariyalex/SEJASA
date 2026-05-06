import 'package:equatable/equatable.dart';

enum ProjectFilterType { completed, ongoing, cancled }

class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadUploadedProjects extends ProjectEvent {}

class LoadTakenProjects extends ProjectEvent {}

class FilterProjects extends ProjectEvent {
  final ProjectFilterType projectFilterType;
  const FilterProjects(this.projectFilterType);

  @override
  List<Object?> get props => [projectFilterType];
}
