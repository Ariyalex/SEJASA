import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_event.dart';
import 'package:sejasa/modules/my_project/bloc/my_project_state.dart';

class MyProjectBloc extends Bloc<MyProjectEvent, MyProjectState> {
  final ProjectRepository _repository;
  MyProjectBloc(this._repository) : super(MyProjectState()) {
    on<LoadMyTakenProjects>(_onLoadTakenProject);
    on<LoadMyUploadedProjects>(_onLoadUploadedProject);
    on<SetMyProjectFilterType>(_onSetProjectFilterType);
  }

  Future<void> _onLoadUploadedProject(
    LoadMyUploadedProjects event,
    Emitter<MyProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectUploaded: true));
    try {
      final projects = await _repository.getMyProjects();
      emit(
        state.copyWith(
          uploadedProjects: projects,
          status: MyProjectStatus.success,
          isFetchingProjectUploaded: false,
        ),
      );
      add(SetMyProjectFilterType(state.filterType));
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: MyProjectStatus.error,
          isFetchingProjectUploaded: false,
        ),
      );
    }
  }

  Future<void> _onLoadTakenProject(
    LoadMyTakenProjects event,
    Emitter<MyProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectTaken: true));
    try {
      final projects = await _repository.getMyProjects();
      emit(
        state.copyWith(
          takenProjects: projects,
          status: MyProjectStatus.success,
          isFetchingProjectTaken: false,
        ),
      );
      add(SetMyProjectFilterType(state.filterType));
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: MyProjectStatus.error,
          isFetchingProjectTaken: false,
        ),
      );
    }
  }

  Future<void> _onSetProjectFilterType(
    SetMyProjectFilterType event,
    Emitter<MyProjectState> emit,
  ) async {
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
