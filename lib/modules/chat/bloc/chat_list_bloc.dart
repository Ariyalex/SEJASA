import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/chat_repository.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/data/payloads/review_project_participant_payload.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_event.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository _chatRepository;
  final ProjectRepository _projectRepository;

  ChatListBloc(
    this._chatRepository,
    this._projectRepository,
  ) : super(const ChatListState()) {
    on<LoadUserChats>(_onLoadUserChats);
    on<LoadProjectChats>(_onLoadProjectChats);
    on<ReviewParticipant>(_onReviewParticipant);
    on<ReviewAllParticipants>(_onReviewAllParticipants);
  }

  Future<void> _onLoadUserChats(
    LoadUserChats event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final chats = await _chatRepository.getListUserChat();
      emit(state.copyWith(
        status: ChatListStatus.loaded,
        chats: chats,
        projectStatus: null, // User chats don't belong to a single project
      ));
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
      final project = await _projectRepository.getProject(event.projectId);
      emit(state.copyWith(
        status: ChatListStatus.loaded,
        chats: chats,
        projectStatus: project.status,
      ));
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

  Future<void> _onReviewParticipant(
    ReviewParticipant event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await _projectRepository.reviewProjectParticipant(
        ReviewProjectParticipantPayload(
          projectId: event.projectId,
          participantId: event.participantId,
          rating: event.rating,
          review: event.review,
        ),
      );
      // Automatically refresh the list of project chats
      final chats = await _chatRepository.getListProjectChat(event.projectId);
      emit(state.copyWith(chats: chats));
      event.onComplete?.call(null);
    } catch (e, stackTrace) {
      LogUtils.e("Failed to review participant ${event.participantId}", e, stackTrace);
      event.onComplete?.call(e.toString());
    }
  }

  Future<void> _onReviewAllParticipants(
    ReviewAllParticipants event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      await _projectRepository.reviewAllProjectParticipant(
        projectId: event.projectId,
        rating: event.rating,
        review: event.review,
      );
      // Automatically refresh the list of project chats
      final chats = await _chatRepository.getListProjectChat(event.projectId);
      emit(state.copyWith(chats: chats));
      event.onComplete?.call(null);
    } catch (e, stackTrace) {
      LogUtils.e("Failed to review all participants for project ${event.projectId}", e, stackTrace);
      event.onComplete?.call(e.toString());
    }
  }
}
