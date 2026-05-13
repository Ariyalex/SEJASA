import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/entities/project_entity.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatEntity> messages;
  final ProjectEntity? project;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.project,
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatEntity>? messages,
    ProjectEntity? project,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      project: project ?? this.project,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, project, errorMessage];
}
