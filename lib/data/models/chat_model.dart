import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';

class ChatModel extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isMe;

  const ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isMe,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_me': isMe,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String? ?? '',
      senderId: json['sender_id'] as String? ?? '',
      receiverId: json['receiver_id'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isMe: json['is_me'] as bool? ?? false,
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      isMe: isMe,
    );
  }

  @override
  List<Object?> get props => [
    id,
    senderId,
    receiverId,
    message,
    timestamp,
    isMe,
  ];
}
