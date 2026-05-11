import 'package:equatable/equatable.dart';
import 'package:sejasa/data/entities/project.dart';

class ProjectFormEvent extends Equatable {
  const ProjectFormEvent();

  @override
  List<Object?> get props => [];
}

class AddNewProject extends ProjectFormEvent {
  final Project newProject;
  const AddNewProject(this.newProject);

  @override
  List<Object?> get props => [newProject];
}

class EditProject extends ProjectFormEvent {
  final Project editedProject;
  const EditProject(this.editedProject);

  @override
  List<Object?> get props => [editedProject];
}
