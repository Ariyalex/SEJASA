import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/entities/project_entity.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatEntity> messages;
  final ProjectEntity? project;
  final String? errorMessage;
  final bool isFetchingProject;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.project,
    this.errorMessage,
    this.isFetchingProject = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatEntity>? messages,
    ProjectEntity? project,
    String? errorMessage,
    bool? isFetchingProject,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      project: project ?? this.project,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetchingProject: isFetchingProject ?? this.isFetchingProject,
    );
  }

  @override
  List<Object?> get props => [
    status,
    messages,
    project,
    errorMessage,
    isFetchingProject,
  ];
}
