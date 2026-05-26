import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserChats extends ChatListEvent {
  const LoadUserChats();
}

class LoadProjectChats extends ChatListEvent {
  final String projectId;

  const LoadProjectChats(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
