import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';

class ChatModel extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final String? file;
  final bool isRead;
  final DateTime timestamp;
  final bool isMe;

  const ChatModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': message,
      'message': message,
      'file': file,
      'is_read': isRead,
      'send_at': timestamp.toIso8601String(),
      'timestamp': timestamp.toIso8601String(),
      'is_me': isMe,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final senderIdVal = json['sender_id'] as String? ?? '';
    return ChatModel(
      id: json['id'] as String? ?? '',
      chatId: json['chat_id'] as String? ?? '',
      senderId: senderIdVal,
      receiverId: json['receiver_id'] as String? ?? '',
      message: (json['content'] ?? json['message']) as String? ?? '',
      file: json['file'] as String?,
      isRead: (json['is_read'] ?? false) as bool,
      timestamp: json['send_at'] != null
          ? DateTime.parse(json['send_at'] as String)
          : (json['timestamp'] != null
              ? DateTime.parse(json['timestamp'] as String)
              : DateTime.now()),
      isMe: currentUserId != null
          ? (senderIdVal == currentUserId)
          : (json['is_me'] as bool? ?? false),
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      file: file,
      isRead: isRead,
      timestamp: timestamp,
      isMe: isMe,
    );
  }

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
