import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final String? file;
  final bool isRead;
  final DateTime timestamp;
  final bool isMe;

  const ChatEntity({
    required this.id,
    this.chatId = '',
    this.senderId = '',
    this.receiverId = '',
    required this.message,
    this.file,
    this.isRead = false,
    required this.timestamp,
    required this.isMe,
  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    receiverId,
    message,
    file,
    isRead,
    timestamp,
    isMe,
  ];
}
