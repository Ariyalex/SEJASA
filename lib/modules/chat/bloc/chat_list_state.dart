import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

enum ChatListStatus { initial, loading, loaded, error }

class ChatListState extends Equatable {
  final ChatListStatus status;
  final List<ListChatItemEntity> chats;
  final String? errorMessage;
  final ProjectStatus? projectStatus;

  const ChatListState({
    this.status = ChatListStatus.initial,
    this.chats = const [],
    this.errorMessage,
    this.projectStatus,
  });

  ChatListState copyWith({
    ChatListStatus? status,
    List<ListChatItemEntity>? chats,
    String? errorMessage,
    ProjectStatus? projectStatus,
  }) {
    return ChatListState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      errorMessage: errorMessage ?? this.errorMessage,
      projectStatus: projectStatus ?? this.projectStatus,
    );
  }

  @override
  List<Object?> get props => [status, chats, errorMessage, projectStatus];
}
