import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isMe;

  const ChatEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isMe,
  });

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
