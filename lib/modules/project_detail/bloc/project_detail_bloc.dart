import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_event.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectRepository _repository;
  ProjectDetailBloc(this._repository) : super(ProjectDetailState()) {
    on<LoadProject>(_onLoadProject);
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
}
