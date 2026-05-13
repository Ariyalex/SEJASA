import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/project_entity.dart';

class ProjectFormEvent extends Equatable {
  const ProjectFormEvent();

  @override
  List<Object?> get props => [];
}

class AddNewProject extends ProjectFormEvent {
  final ProjectEntity newProject;
  const AddNewProject(this.newProject);

  @override
  List<Object?> get props => [newProject];
}

class EditProject extends ProjectFormEvent {
  final ProjectEntity editedProject;
  const EditProject(this.editedProject);

  @override
  List<Object?> get props => [editedProject];
}
