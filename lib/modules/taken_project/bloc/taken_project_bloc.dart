import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/taken_project/bloc/taken_project_event.dart';
import 'package:sejasa/modules/taken_project/bloc/taken_project_state.dart';

class TakenProjectBloc extends Bloc<TakenProjectEvent, TakenProjectState> {
  final ProjectRepository _repository;
  TakenProjectBloc(this._repository) : super(const TakenProjectState()) {
    on<LoadTakenPendingProjects>(_onLoadPendingProjects);
    on<LoadTakenRejectedProjects>(_onLoadRejectedProjects);
    on<LoadTakenAcceptedProjects>(_onLoadAcceptedProjects);
    on<SetTakenProjectFilterType>(_onSetProjectFilterType);
    on<ReviewTakenProject>(_onReviewProject);
  }

  Future<void> _onLoadPendingProjects(
    LoadTakenPendingProjects event,
    Emitter<TakenProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingPendingProjects: true));
    try {
      final projects = await _repository.getPendingProjects(event.userId);
      emit(
        state.copyWith(
          pendingProjects: projects,
          status: TakenProjectStatus.success,
          isFetchingPendingProjects: false,
        ),
      );
      add(SetTakenProjectFilterType(state.filterType));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: TakenProjectStatus.error,
          isFetchingPendingProjects: false,
        ),
      );
    }
  }

  Future<void> _onLoadAcceptedProjects(
    LoadTakenAcceptedProjects event,
    Emitter<TakenProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingAcceptedProjects: true));
    try {
      final projects = await _repository.getAcceptedProjects(event.userId);
      emit(
        state.copyWith(
          acceptedProjects: projects,
          status: TakenProjectStatus.success,
          isFetchingAcceptedProjects: false,
        ),
      );
      add(SetTakenProjectFilterType(state.filterType));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: TakenProjectStatus.error,
          isFetchingAcceptedProjects: false,
        ),
      );
    }
  }

  Future<void> _onLoadRejectedProjects(
    LoadTakenRejectedProjects event,
    Emitter<TakenProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingRejectedProjects: true));
    try {
      final projects = await _repository.getRejectedProjects(event.userId);
      emit(
        state.copyWith(
          rejectedProjects: projects,
          status: TakenProjectStatus.success,
          isFetchingRejectedProjects: false,
        ),
      );
      add(SetTakenProjectFilterType(state.filterType));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: TakenProjectStatus.error,
          isFetchingRejectedProjects: false,
        ),
      );
    }
  }

  Future<void> _onSetProjectFilterType(
    SetTakenProjectFilterType event,
    Emitter<TakenProjectState> emit,
  ) async {
    final List<ProjectEntity> pendingProjects;
    final List<ProjectEntity> acceptedProjects;
    final List<ProjectEntity> rejectedProjects;
    if (event.projectFilterType == ProjectFilterType.all) {
      pendingProjects = state.pendingProjects;
      acceptedProjects = state.acceptedProjects;
      rejectedProjects = state.rejectedProjects;
    } else {
      ProjectStatus? statusToMatch;
      switch (event.projectFilterType) {
        case ProjectFilterType.hiring:
          statusToMatch = ProjectStatus.hiring;
          break;
        case ProjectFilterType.going:
          statusToMatch = ProjectStatus.going;
          break;
        case ProjectFilterType.completed:
          statusToMatch = ProjectStatus.completed;
          break;
        case ProjectFilterType.cancled:
          statusToMatch = ProjectStatus.cancled;
          break;
        default:
          break;
      }

      if (statusToMatch != null) {
        pendingProjects = state.pendingProjects
            .where((element) => element.status == statusToMatch)
            .toList();
        acceptedProjects = state.acceptedProjects
            .where((element) => element.status == statusToMatch)
            .toList();
        rejectedProjects = state.rejectedProjects
            .where((element) => element.status == statusToMatch)
            .toList();
      } else {
        pendingProjects = [];
        acceptedProjects = [];
        rejectedProjects = [];
      }
    }

    emit(
      state.copyWith(
        filterType: event.projectFilterType,
        filteredPendingProjects: pendingProjects,
        filteredAcceptedProjects: acceptedProjects,
        filteredRejectedProjects: rejectedProjects,
      ),
    );
  }

  Future<void> _onReviewProject(
    ReviewTakenProject event,
    Emitter<TakenProjectState> emit,
  ) async {
    emit(state.copyWith(status: TakenProjectStatus.loading));
    try {
      await _repository.reviewProject(
        projectId: event.projectId,
        rating: event.rating,
        review: event.review,
      );
      // Automatically refresh the accepted projects
      add(LoadTakenAcceptedProjects(event.userId));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: TakenProjectStatus.error,
        ),
      );
    }
  }
}
