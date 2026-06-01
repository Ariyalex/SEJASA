import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';

class ProfilProjectEvent extends Equatable {
  const ProfilProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyUploadedProjects extends ProfilProjectEvent {
  final String userId;
  const LoadMyUploadedProjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadMyTakenProjects extends ProfilProjectEvent {
  final String userId;
  const LoadMyTakenProjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SetCompletedProjects extends ProfilProjectEvent {
  final ProjectFilterType projectFilterType;
  const SetCompletedProjects(this.projectFilterType);

  @override
  List<Object?> get props => [projectFilterType];
}

class LoadUserProfile extends ProfilProjectEvent {
  final String userId;
  final bool isMyProfile;
  const LoadUserProfile(this.userId, {required this.isMyProfile});

  @override
  List<Object?> get props => [userId, isMyProfile];
}
