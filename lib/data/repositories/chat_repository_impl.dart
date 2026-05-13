import 'package:sejasa/data/models/chat_model.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketProvider _chatSocketProvider;

  ChatRepositoryImpl(this._chatSocketProvider);

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
  void connect(String url) {
    _chatSocketProvider.connect(url);
  }

  @override
  void disconnect() {
    _chatSocketProvider.disconnect();
  }

  @override
  Future<List<ChatEntity>> getChatHistory(String? projectId) async {
    // Stubbed implementation
    return [];
  }
}
