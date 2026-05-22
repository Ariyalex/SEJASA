import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';

enum ChatListStatus { initial, loading, loaded, error }

class ChatListState extends Equatable {
  final ChatListStatus status;
  final List<ListChatItemEntity> chats;
  final String? errorMessage;

  const ChatListState({
    this.status = ChatListStatus.initial,
    this.chats = const [],
    this.errorMessage,
  });

  ChatListState copyWith({
    ChatListStatus? status,
    List<ListChatItemEntity>? chats,
    String? errorMessage,
  }) {
    return ChatListState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, chats, errorMessage];
}
