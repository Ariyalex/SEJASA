import 'package:equatable/equatable.dart';

class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProject extends ProjectDetailEvent {
  final String id;
  final bool isAuthenticated;
  const LoadProject(this.id, {this.isAuthenticated = false});

  @override
  List<Object?> get props => [id, isAuthenticated];
}

class ApplyToProject extends ProjectDetailEvent {
  const ApplyToProject();

  @override
  List<Object?> get props => [];
}

class ReviewProject extends ProjectDetailEvent {
  final double rating;
  final String review;

  const ReviewProject({
    required this.rating,
    required this.review,
  });

  @override
  List<Object?> get props => [rating, review];
}
