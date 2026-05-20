import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';

class MyProjectEvent extends Equatable {
  const MyProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyPendingProjects extends MyProjectEvent {
  final String userId;
  const LoadMyPendingProjects(this.userId);
  @override
  List<Object?> get props => [userId];
}

class LoadMyAcceptedProjects extends MyProjectEvent {
  final String userId;
  const LoadMyAcceptedProjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadMyRejectedProjects extends MyProjectEvent {
  final String userId;
  const LoadMyRejectedProjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SetMyProjectFilterType extends MyProjectEvent {
  final ProjectFilterType projectFilterType;
  const SetMyProjectFilterType(this.projectFilterType);

  @override
  List<Object?> get props => [projectFilterType];
}
