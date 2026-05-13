import 'package:equatable/equatable.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';

class MyProjectEvent extends Equatable {
  const MyProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyUploadedProjects extends MyProjectEvent {}

class LoadMyTakenProjects extends MyProjectEvent {}

class SetMyProjectFilterType extends MyProjectEvent {
  final ProjectFilterType projectFilterType;
  const SetMyProjectFilterType(this.projectFilterType);

  @override
  List<Object?> get props => [projectFilterType];
}
