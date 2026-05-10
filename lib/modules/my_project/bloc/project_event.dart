import 'package:equatable/equatable.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';

class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadUploadedProjects extends ProjectEvent {}

class LoadTakenProjects extends ProjectEvent {}

class SetProjectFilterType extends ProjectEvent {
  final ProjectFilterType projectFilterType;
  const SetProjectFilterType(this.projectFilterType);

  @override
  List<Object?> get props => [projectFilterType];
}
