import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_event.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectRepository _repository;
  ProjectDetailBloc(this._repository) : super(ProjectDetailState()) {
    on<LoadProject>(_onLoadProject);
    on<ApplyToProject>(_onApplyToProject);
    on<ReviewProject>(_onReviewProject);
  }

  Future<void> _onLoadProject(
    LoadProject event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProjectDetailStatus.loading,
        isAuthenticated: event.isAuthenticated,
      ),
    );
    try {
      final project = await _repository.getProject(event.id);
      emit(
        state.copyWith(project: project, status: ProjectDetailStatus.success),
      );
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProjectDetailStatus.error,
        ),
      );
    }
  }

  Future<void> _onApplyToProject(
    ApplyToProject event,
    Emitter<ProjectDetailState> emit,
  ) async {
    final project = state.project;
    if (project == null) return;

    emit(state.copyWith(status: ProjectDetailStatus.applyLoading));
    try {
      final response = await _repository.applyPorject(project.id);
      emit(
        state.copyWith(
          status: ProjectDetailStatus.applySuccess,
          appliedChatId: response.chatId,
          appliedProjectId: response.projectId,
        ),
      );
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProjectDetailStatus.applyError,
        ),
      );
    }
  }

  Future<void> _onReviewProject(
    ReviewProject event,
    Emitter<ProjectDetailState> emit,
  ) async {
    final project = state.project;
    if (project == null) return;

    emit(state.copyWith(status: ProjectDetailStatus.loading));
    try {
      await _repository.reviewProject(
        projectId: project.id,
        rating: event.rating,
        review: event.review,
      );
      final updatedProject = await _repository.getProject(project.id);
      emit(
        state.copyWith(
          project: updatedProject,
          status: ProjectDetailStatus.success,
        ),
      );
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProjectDetailStatus.error,
        ),
      );
    }
  }
}
