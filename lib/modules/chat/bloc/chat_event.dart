import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final String projectId;
  const ChatStarted(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class SendMessage extends ChatEvent {
  final String message;
  const SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageReceived extends ChatEvent {
  final ChatEntity message;
  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}
