import 'package:sejasa/data/models/chat_model.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';
import 'package:sejasa/domain/providers/remote_chat_provider.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketProvider _chatSocketProvider;
  final RemoteChatProvider _chatProvider;

  ChatRepositoryImpl(this._chatSocketProvider, this._chatProvider);

  @override
  Stream<ChatEntity> get messagesStream {
    return _chatSocketProvider.messageStream.map((model) => model.toEntity());
  }

  @override
  void sendMessage(ChatEntity message) {
    final model = ChatModel(
      id: message.id,
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      timestamp: message.timestamp,
      isMe: message.isMe,
    );
    _chatSocketProvider.sendMessage(model);
  }

  @override
  Future<List<ListChatItemEntity>> getListProjectChat(String projectId) async {
    final response = await _chatProvider.getListProjectChat(projectId);
    return List<ListChatItemEntity>.from(response.map((e) => e.toEntity()));
  }

  @override
  Future<List<ListChatItemEntity>> getListUserChat() async {
    final response = await _chatProvider.getListUserChat();
    return List<ListChatItemEntity>.from(response.map((e) => e.toEntity()));
  }

  @override
  void connect(String url) {
    _chatSocketProvider.connect(url);
  }

  @override
  void disconnect() {
    _chatSocketProvider.disconnect();
  }
}
