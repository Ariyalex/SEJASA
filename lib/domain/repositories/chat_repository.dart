import 'package:sejasa/domain/entities/chat_entity.dart';

abstract class ChatRepository {
  Stream<ChatEntity> get messagesStream;
  void sendMessage(ChatEntity message);
  void connect(String url);
  void disconnect();
  Future<List<ChatEntity>> getChatHistory(String? projectId); // Stubbed
}
