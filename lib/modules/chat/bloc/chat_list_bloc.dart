import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_event.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository _chatRepository;

  ChatListBloc(this._chatRepository) : super(const ChatListState()) {
    on<LoadUserChats>(_onLoadUserChats);
    on<LoadProjectChats>(_onLoadProjectChats);
  }

  Future<void> _onLoadUserChats(
    LoadUserChats event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final chats = await _chatRepository.getListUserChat();
      emit(state.copyWith(status: ChatListStatus.loaded, chats: chats));
    } catch (e, stackTrace) {
      LogUtils.e("Failed to load user chats", e, stackTrace);
      emit(
        state.copyWith(
          status: ChatListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadProjectChats(
    LoadProjectChats event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final chats = await _chatRepository.getListProjectChat(event.projectId);
      emit(state.copyWith(status: ChatListStatus.loaded, chats: chats));
    } catch (e, stackTrace) {
      LogUtils.e("Failed to load project chats for project ${event.projectId}", e, stackTrace);
      emit(
        state.copyWith(
          status: ChatListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
