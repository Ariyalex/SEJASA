import 'package:sejasa/data/models/chat_model.dart';

abstract class ChatSocketProvider {
  Stream<ChatModel> get messageStream;
  void sendMessage(ChatModel chat);
  void connect(String url);
  void disconnect();
}
