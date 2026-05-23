import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final String chatId;
  final bool isOwner;
  const ChatStarted({required this.chatId, required this.isOwner});

  @override
  List<Object?> get props => [chatId, isOwner];
}

class SendMessage extends ChatEvent {
  final String message;
  final String? file;
  const SendMessage(this.message, {this.file});

  @override
  List<Object?> get props => [message, file];
}

class MessageReceived extends ChatEvent {
  final ChatEntity message;
  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class LoadChatProject extends ChatEvent {
  final String projectId;
  const LoadChatProject(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
