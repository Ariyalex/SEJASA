import 'package:equatable/equatable.dart';

class ListChatUserEntity extends Equatable {
  final String id;
  final String name;
  final String? image;

  const ListChatUserEntity({
    required this.id,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}

class ListChatItemEntity extends Equatable {
  final String id;
  final String projectId;
  final ListChatUserEntity user;
  final String title;
  final String body;
  final int unreadMsg;
  final DateTime timestamp;

  const ListChatItemEntity({
    required this.id,
    required this.projectId,
    required this.user,
    required this.title,
    required this.body,
    required this.unreadMsg,
    required this.timestamp,
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
      ];
}
