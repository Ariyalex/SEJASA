import 'package:equatable/equatable.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';

class ProjectFormEvent extends Equatable {
  const ProjectFormEvent();

  @override
  List<Object?> get props => [];
}

class AddNewProject extends ProjectFormEvent {
  final ProjectCreatePayload payload;
  const AddNewProject(this.payload);

  @override
  List<Object?> get props => [payload];
}

class EditProject extends ProjectFormEvent {
  final ProjectUpdatePayload payload;
  const EditProject(this.payload);

  @override
  List<Object?> get props => [payload];
}

class LoadAllProjectCategories extends ProjectFormEvent {}
