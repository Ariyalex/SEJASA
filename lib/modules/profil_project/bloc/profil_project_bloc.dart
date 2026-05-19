import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_event.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_state.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';

class ProfilProjectBloc extends Bloc<ProfilProjectEvent, ProfilProjectState> {
  final ProjectRepository _repository;
  ProfilProjectBloc(this._repository) : super(ProfilProjectState()) {
    on<LoadUserProjects>(_onLoadTakenProject);
    on<LoadMyUploadedProjects>(_onLoadUploadedProject);
  }

  Future<void> _onLoadUploadedProject(
    LoadMyUploadedProjects event,
    Emitter<ProfilProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectUploaded: true));
    try {
      final projects = await _repository.getUploadedProjects();
      emit(
        state.copyWith(
          uploadedProjects: projects,
          status: ProfilProjectStatus.success,
          isFetchingProjectUploaded: false,
        ),
      );
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProfilProjectStatus.error,
          isFetchingProjectUploaded: false,
        ),
      );
    }
  }

  Future<void> _onLoadTakenProject(
    LoadUserProjects event,
    Emitter<ProfilProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectTaken: true));
    try {
      final projects = await _repository.getUserProjects(event.userId);
      final completedProjects = projects
          .where(
            (element) =>
                element.status.toJson == ProjectFilterType.completed.toJson,
          )
          .toList();
      emit(
        state.copyWith(
          takenProjects: completedProjects,
          status: ProfilProjectStatus.success,
          isFetchingProjectTaken: false,
        ),
      );
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProfilProjectStatus.error,
          isFetchingProjectTaken: false,
        ),
      );
    }
  }
}
