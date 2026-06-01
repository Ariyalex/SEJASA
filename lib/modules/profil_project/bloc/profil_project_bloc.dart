import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_event.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_state.dart';

class ProfilProjectBloc extends Bloc<ProfilProjectEvent, ProfilProjectState> {
  final ProjectRepository _repository;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  ProfilProjectBloc(
    this._repository,
    this._userRepository,
    this._authRepository,
  ) : super(ProfilProjectState()) {
    on<LoadMyUploadedProjects>(_onLoadUploadedProjects);
    on<LoadMyTakenProjects>(_onLoadTakenProjects);
    on<SetCompletedProjects>(_onSetCompletedProjects);
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onLoadUploadedProjects(
    LoadMyUploadedProjects event,
    Emitter<ProfilProjectState> emit,
  ) async {
    emit(state.copyWith(
      isFetchingProjectUploaded: true,
      status: ProfilProjectStatus.loading,
    ));
    try {
      final projects = await _repository.getUploadedProjects(event.userId);
      final filtered = _filterProjects(projects, state.filterType);
      emit(
        state.copyWith(
          uploadedProjects: projects,
          filteredUploadedProjects: filtered,
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

  Future<void> _onLoadTakenProjects(
    LoadMyTakenProjects event,
    Emitter<ProfilProjectState> emit,
  ) async {
    emit(state.copyWith(
      isFetchingProjectTaken: true,
      status: ProfilProjectStatus.loading,
    ));
    try {
      final projects = await _repository.getAcceptedProjects(event.userId);
      emit(
        state.copyWith(
          takenProjects: projects,
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

  void _onSetCompletedProjects(
    SetCompletedProjects event,
    Emitter<ProfilProjectState> emit,
  ) {
    final filtered = _filterProjects(state.uploadedProjects, event.projectFilterType);
    emit(
      state.copyWith(
        filterType: event.projectFilterType,
        filteredUploadedProjects: filtered,
      ),
    );
  }

  List<ProjectEntity> _filterProjects(
    List<ProjectEntity> allProjects,
    ProjectFilterType filterType,
  ) {
    if (filterType == ProjectFilterType.all) {
      return allProjects;
    }
    ProjectStatus? statusToMatch;
    switch (filterType) {
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
      return allProjects.where((p) => p.status == statusToMatch).toList();
    }
    return allProjects;
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfilProjectState> emit,
  ) async {
    emit(state.copyWith(
      isFetchingUserProfile: true,
      status: ProfilProjectStatus.loading,
    ));
    try {
      final user = event.isMyProfile
          ? await _authRepository.getMyProfile()
          : await _userRepository.getUserProfile(event.userId);
      emit(state.copyWith(
        userProfile: user,
        isFetchingUserProfile: false,
        status: ProfilProjectStatus.success,
      ));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(state.copyWith(
        message: e.toString(),
        status: ProfilProjectStatus.error,
        isFetchingUserProfile: false,
      ));
    }
  }
}
