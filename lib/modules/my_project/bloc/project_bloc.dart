import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/repositories/project_repository.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';
import 'package:sejasa/modules/my_project/bloc/project_event.dart';
import 'package:sejasa/modules/my_project/bloc/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _repository;
  ProjectBloc(this._repository) : super(ProjectState()) {
    on<LoadTakenProjects>(_onLoadTakenProject);
    on<LoadUploadedProjects>(_onLoadUploadedProject);
    on<SetProjectFilterType>(_onSetProjectFilterType);
  }

  Future<void> _onLoadUploadedProject(
    LoadUploadedProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectUploaded: true));
    try {
      final projects = await _repository.getMyProjects();
      emit(
        state.copyWith(
          uploadedProjects: projects,
          status: ProjectBlocStatus.success,
          isFetchingProjectUploaded: false,
        ),
      );
      add(SetProjectFilterType(state.filterType));
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProjectBlocStatus.error,
          isFetchingProjectUploaded: false,
        ),
      );
    }
  }

  Future<void> _onLoadTakenProject(
    LoadTakenProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectTaken: true));
    try {
      final projects = await _repository.getMyProjects();
      emit(
        state.copyWith(
          takenProjects: projects,
          status: ProjectBlocStatus.success,
          isFetchingProjectTaken: false,
        ),
      );
      add(SetProjectFilterType(state.filterType));
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProjectBlocStatus.error,
          isFetchingProjectTaken: false,
        ),
      );
    }
  }

  Future<void> _onSetProjectFilterType(
    SetProjectFilterType event,
    Emitter<ProjectState> emit,
  ) async {
    if (state.filterType != event.projectFilterType) {
      final List<Project> takenProjects;
      final List<Project> uploadedProjects;
      if (event.projectFilterType == ProjectFilterType.all) {
        takenProjects = state.takenProjects;
        uploadedProjects = state.uploadedProjects;
      } else {
        takenProjects = state.takenProjects
            .where(
              (element) =>
                  element.status.toJson == event.projectFilterType.toJson,
            )
            .toList();
        uploadedProjects = state.uploadedProjects
            .where(
              (element) =>
                  element.status.toJson == event.projectFilterType.toJson,
            )
            .toList();
      }
      emit(
        state.copyWith(
          filterType: event.projectFilterType,
          filteredTakenProjects: takenProjects,
          filteredUploadedProjects: uploadedProjects,
        ),
      );
    }
  }
}
