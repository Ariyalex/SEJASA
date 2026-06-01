import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';

abstract class ChatRepository {
  Stream<ChatEntity> get messagesStream;
  void sendMessage(ChatEntity message);
  void connect(String url);
  void disconnect();

  Future<List<ListChatItemEntity>> getListUserChat();
  Future<List<ListChatItemEntity>> getListProjectChat(String projectId);
}
