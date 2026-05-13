import 'dart:async';
import 'package:sejasa/data/models/chat_model.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';

class MockChatSocketProvider implements ChatSocketProvider {
  final _messageController = StreamController<ChatModel>.broadcast();

  @override
  Stream<ChatModel> get messageStream => _messageController.stream;

  @override
  void sendMessage(ChatModel chat) {
    // Simulate auto-reply after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!_messageController.isClosed) {
        final response = ChatModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'opponent',
          receiverId: chat.senderId,
          message: 'Ini adalah balasan mockup untuk pesan Anda: "${chat.message}"',
          timestamp: DateTime.now(),
          isMe: false,
        );
        _messageController.add(response);
      }
    });
  }

  @override
  void connect(String url) {
    // Do nothing for mock
  }

  @override
  void disconnect() {
    // Tidak menutup StreamController pada mock provider agar bisa
    // digunakan kembali saat masuk ke ChatScreen lagi.
  }
}
