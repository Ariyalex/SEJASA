import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';

class TakenProjectEvent extends Equatable {
  const TakenProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadTakenPendingProjects extends TakenProjectEvent {
  final String userId;
  const LoadTakenPendingProjects(this.userId);
  @override
  List<Object?> get props => [userId];
}

class LoadTakenAcceptedProjects extends TakenProjectEvent {
  final String userId;
  const LoadTakenAcceptedProjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadTakenRejectedProjects extends TakenProjectEvent {
  final String userId;
  const LoadTakenRejectedProjects(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SetTakenProjectFilterType extends TakenProjectEvent {
  final ProjectFilterType projectFilterType;
  const SetTakenProjectFilterType(this.projectFilterType);

  @override
  List<Object?> get props => [projectFilterType];
}

class ReviewTakenProject extends TakenProjectEvent {
  final String projectId;
  final double rating;
  final String review;
  final String userId;

  const ReviewTakenProject({
    required this.projectId,
    required this.rating,
    required this.review,
    required this.userId,
  });

  @override
  List<Object?> get props => [projectId, rating, review, userId];
}
