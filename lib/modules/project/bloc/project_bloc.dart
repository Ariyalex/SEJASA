import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/data/repositories/project_repository.dart';
import 'package:sejasa/modules/project/bloc/project_event.dart';
import 'package:sejasa/modules/project/bloc/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _repository;
  ProjectBloc(this._repository) : super(ProjectState()) {
    on<LoadTakenProjects>(_onLoadTakenProject);
    on<LoadUploadedProjects>(_onLoadUploadedProject);
  }

  Future<void> _onLoadUploadedProject(
    LoadUploadedProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(status: ProjectBlocStatus.loading));
    try {
      final projects = await _repository.getMyProjects();
      emit(
        state.copyWith(
          projectsUploaded: projects,
          status: ProjectBlocStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(message: e.toString(), status: ProjectBlocStatus.error),
      );
    }
  }

  Future<void> _onLoadTakenProject(
    LoadTakenProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(status: ProjectBlocStatus.loading));
    try {
      final projects = await _repository.getMyProjects();
      emit(
        state.copyWith(
          projectsTaken: projects,
          status: ProjectBlocStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(message: e.toString(), status: ProjectBlocStatus.error),
      );
    }
  }
}
