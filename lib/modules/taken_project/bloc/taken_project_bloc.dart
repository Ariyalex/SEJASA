import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_event.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_state.dart';

class MyProjectBloc extends Bloc<MyProjectEvent, MyProjectState> {
  final ProjectRepository _repository;
  MyProjectBloc(this._repository) : super(MyProjectState()) {
    on<LoadMyPendingProjects>(_onLoadPendingProjects);
    on<LoadMyRejectedProjects>(_onLoadRejectedProjects);
    on<LoadMyAcceptedProjects>(_onLoadAcceptedProjects);
    on<SetMyProjectFilterType>(_onSetProjectFilterType);
  }

  Future<void> _onLoadPendingProjects(
    LoadMyPendingProjects event,
    Emitter<MyProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingPendingProjects: true));
    try {
      final projects = await _repository.getPendingProjects(event.userId);
      emit(
        state.copyWith(
          pendingProjects: projects,
          status: MyProjectStatus.success,
          isFetchingPendingProjects: false,
        ),
      );
      add(SetMyProjectFilterType(state.filterType));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: MyProjectStatus.error,
          isFetchingPendingProjects: false,
        ),
      );
    }
  }

  Future<void> _onLoadAcceptedProjects(
    LoadMyAcceptedProjects event,
    Emitter<MyProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingAcceptedProjects: true));
    try {
      final projects = await _repository.getAcceptedProjects(event.userId);
      emit(
        state.copyWith(
          acceptedProjects: projects,
          status: MyProjectStatus.success,
          isFetchingAcceptedProjects: false,
        ),
      );
      add(SetMyProjectFilterType(state.filterType));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: MyProjectStatus.error,
          isFetchingAcceptedProjects: false,
        ),
      );
    }
  }

  Future<void> _onLoadRejectedProjects(
    LoadMyRejectedProjects event,
    Emitter<MyProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingRejectedProjects: true));
    try {
      final projects = await _repository.getRejectedProjects(event.userId);
      emit(
        state.copyWith(
          rejectedProjects: projects,
          status: MyProjectStatus.success,
          isFetchingRejectedProjects: false,
        ),
      );
      add(SetMyProjectFilterType(state.filterType));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: MyProjectStatus.error,
          isFetchingRejectedProjects: false,
        ),
      );
    }
  }

  Future<void> _onSetProjectFilterType(
    SetMyProjectFilterType event,
    Emitter<MyProjectState> emit,
  ) async {
    final List<ProjectEntity> pendingProjects;
    final List<ProjectEntity> acceptedProjects;
    final List<ProjectEntity> rejectedProjects;
    if (event.projectFilterType == ProjectFilterType.all) {
      pendingProjects = state.pendingProjects;
      acceptedProjects = state.acceptedProjects;
      rejectedProjects = state.rejectedProjects;
    } else {
      pendingProjects = state.pendingProjects
          .where(
            (element) =>
                element.status.toJson == event.projectFilterType.toJson,
          )
          .toList();
      acceptedProjects = state.acceptedProjects
          .where(
            (element) =>
                element.status.toJson == event.projectFilterType.toJson,
          )
          .toList();
      rejectedProjects = state.rejectedProjects
          .where(
            (element) =>
                element.status.toJson == event.projectFilterType.toJson,
          )
          .toList();
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
}
