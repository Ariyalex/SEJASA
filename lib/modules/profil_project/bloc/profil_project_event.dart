import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';

class ProfilProjectEvent extends Equatable {
  const ProfilProjectEvent();

  @override
  List<Object?> get props => [];
}

// class LoadAllMyProjects extends ProfilProjectEvent {}

class LoadUserProjects extends ProfilProjectEvent {
  final String userId;
  const LoadUserProjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadMyUploadedProjects extends ProfilProjectEvent {}

class SetCompletedProjects extends ProfilProjectEvent {
  final ProjectFilterType projectFilterType;
  const SetCompletedProjects(this.projectFilterType);

  @override
  List<Object?> get props => [projectFilterType];
}
