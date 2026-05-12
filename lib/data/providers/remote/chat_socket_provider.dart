import 'dart:convert';
import 'package:sejasa/core/services/socket_service.dart';
import 'package:sejasa/data/models/chat_model.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';

class ChatSocketProviderImpl implements ChatSocketProvider {
  final SocketService _socketService;

  ChatSocketProviderImpl(this._socketService);

  @override
  Stream<ChatModel> get messageStream {
    return _socketService.stream.map((data) {
      final decoded = jsonDecode(data as String) as Map<String, dynamic>;
      return ChatModel.fromJson(decoded);
    });
  }

  @override
  void sendMessage(ChatModel chat) {
    final data = jsonEncode(chat.toJson());
    _socketService.send(data);
  }

  @override
  void connect(String url) {
    _socketService.connect(url);
  }

  @override
  void disconnect() {
    _socketService.disconnect();
  }
}
