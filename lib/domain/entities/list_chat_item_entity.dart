import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';

class ListChatUserEntity extends Equatable {
  final String id;
  final String name;
  final String? image;

  const ListChatUserEntity({required this.id, required this.name, this.image});

  @override
  List<Object?> get props => [id, name, image];
}

class ListChatItemEntity extends Equatable {
  final String id;
  final String projectId;
  final String projectName;
  final ListChatUserEntity user;
  final String title;
  final String body;
  final int unreadMsg;
  final DateTime timestamp;
  final double givenRating;
  final ParticipantStatusType? participantStatus;

  const ListChatItemEntity({
    required this.id,
    required this.projectId,
    required this.user,
    required this.title,
    required this.body,
    required this.unreadMsg,
    required this.timestamp,
    this.participantStatus,
    required this.projectName,
    required this.givenRating,
  });

  @override
  List<Object?> get props => [
    id,
    projectId,
    user,
    title,
    body,
    unreadMsg,
    timestamp,
    participantStatus,
    givenRating,
    projectName,
  ];
}
