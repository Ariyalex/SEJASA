import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/config/app_config.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';
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
    on<AcceptParticipant>(_onAcceptParticipant);
    on<RejectParticipant>(_onRejectParticipant);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      status: ChatStatus.loading,
      participantStatus: event.participantStatus,
    ));
    try {
      final cleanChatId = event.chatId.replaceAll('#', '');
      LogUtils.i('ChatBloc: cleanChatId = "$cleanChatId", raw = "${event.chatId}"');
      final wsUrl = "${AppConfig.wsBaseUrl}/chat/$cleanChatId";

      _chatRepository.connect(wsUrl);

      // Subscribe to messages
      await _messageSubscription?.cancel();
      _messageSubscription = _chatRepository.messagesStream.listen(
        (message) => add(MessageReceived(message)),
      );

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
      senderId: 'me',
      receiverId: 'other',
      message: event.message,
      file: event.file,
      timestamp: DateTime.now(),
      isMe: true,
    );

    _chatRepository.sendMessage(newMessage);
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    // Ignore empty message payloads to prevent blank chat bubbles from rendering
    if (event.message.message.trim().isEmpty &&
        (event.message.file == null || event.message.file!.isEmpty)) {
      return;
    }

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

  Future<void> _onAcceptParticipant(
    AcceptParticipant event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _projectRepository.acceptProjectParticipant(
        event.projectId,
        event.participantId,
      );
      emit(state.copyWith(participantStatus: ParticipantStatusType.accepted));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onRejectParticipant(
    RejectParticipant event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _projectRepository.rejectProjectParticipant(
        event.projectId,
        event.participantId,
      );
      emit(state.copyWith(participantStatus: ParticipantStatusType.rejected));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _chatRepository.disconnect();
    return super.close();
  }
}
