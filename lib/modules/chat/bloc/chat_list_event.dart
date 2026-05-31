import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserChats extends ChatListEvent {
  const LoadUserChats();
}

class LoadProjectChats extends ChatListEvent {
  final String projectId;

  const LoadProjectChats(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class ReviewParticipant extends ChatListEvent {
  final String projectId;
  final String participantId;
  final double rating;
  final String review;
  final void Function(String? error)? onComplete;

  const ReviewParticipant({
    required this.projectId,
    required this.participantId,
    required this.rating,
    required this.review,
    this.onComplete,
  });

  @override
  List<Object?> get props => [projectId, participantId, rating, review, onComplete];
}

class ReviewAllParticipants extends ChatListEvent {
  final String projectId;
  final double rating;
  final String review;
  final void Function(String? error)? onComplete;

  const ReviewAllParticipants({
    required this.projectId,
    required this.rating,
    required this.review,
    this.onComplete,
  });

  @override
  List<Object?> get props => [projectId, rating, review, onComplete];
}
