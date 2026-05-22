import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/chat/bloc/chat_event.dart';
import 'package:sejasa/modules/chat/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final ProjectRepository _projectRepository;
  StreamSubscription<ChatEntity>? _messageSubscription;

  ChatBloc(this._chatRepository, this._projectRepository)
    : super(const ChatState()) {
    on<ChatStarted>(_onChatStarted);
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<LoadChatProject>(_onLoadChatProject);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      // Connect to WebSocket (using echo server for testing)
      // _chatRepository.connect('ws://echo.websocket.events');

      // Subscribe to messages
      await _messageSubscription?.cancel();
      _messageSubscription = _chatRepository.messagesStream.listen(
        (message) => add(MessageReceived(message)),
      );

      // Fetch history (stubbed)
      // final history = await _chatRepository.getChatHistory(event.projectId);
      emit(state.copyWith(status: ChatStatus.loaded));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(status: ChatStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final newMessage = ChatEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me', // Mock
      receiverId: 'other', // Mock
      message: event.message,
      timestamp: DateTime.now(),
      isMe: true,
    );

    _chatRepository.sendMessage(newMessage);

    // Optimistically add to UI (optional, since echo will return it)
    final updatedMessages = List<ChatEntity>.from(state.messages)
      ..add(newMessage);
    emit(state.copyWith(messages: updatedMessages));
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    // If it's already in the list (from optimistic update), don't add again
    if (state.messages.any((m) => m.id == event.message.id)) return;

    final updatedMessages = List<ChatEntity>.from(state.messages)
      ..add(event.message);
    emit(state.copyWith(messages: updatedMessages));
  }

  Future<void> _onLoadChatProject(
    LoadChatProject event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isFetchingProject: true));
    try {
      final project = await _projectRepository.getProject(event.projectId);
      emit(state.copyWith(project: project, isFetchingProject: false));
    } catch (e) {
      emit(
        state.copyWith(
          isFetchingProject: false,
          status: ChatStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _chatRepository.disconnect();
    return super.close();
  }
}
