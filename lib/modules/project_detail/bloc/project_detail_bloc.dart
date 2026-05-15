import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_event.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectRepository _repository;
  ProjectDetailBloc(this._repository) : super(ProjectDetailState()) {
    on<LoadProject>(_onLoadProject);
    on<ToggleProjectBookmark>(_onSetProjectBookmark);
  }

  Future<void> _onLoadProject(
    LoadProject event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(state.copyWith(
      status: ProjectDetailStatus.loading,
      isAuthenticated: event.isAuthenticated,
    ));
    try {
      final project = await _repository.getProject(event.id);
      emit(
        state.copyWith(project: project, status: ProjectDetailStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProjectDetailStatus.error,
        ),
      );
    }
  }

  Future<void> _onSetProjectBookmark(
    ToggleProjectBookmark event,
    Emitter<ProjectDetailState> emit,
  ) async {
    try {
      final newProject = state.project?.copyWith(
        isBookmark: !(state.project?.isBookmark ?? true),
      );

      emit(state.copyWith(project: newProject));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProjectDetailStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
