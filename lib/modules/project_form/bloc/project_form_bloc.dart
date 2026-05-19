import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/project_form/bloc/project_form_event.dart';
import 'package:sejasa/modules/project_form/bloc/project_form_state.dart';

class ProjectFormBloc extends Bloc<ProjectFormEvent, ProjectFormState> {
  final ProjectRepository _repository;
  ProjectFormBloc(this._repository) : super(ProjectFormState()) {
    on<AddNewProject>(_onAddNewProject);
    on<EditProject>(_onEditProject);
    on<LoadAllProjectCategories>(_onLoadAllProjectCategories);
  }

  Future<void> _onAddNewProject(
    AddNewProject event,
    Emitter<ProjectFormState> emit,
  ) async {
    emit(state.copyWith(status: ProjectFormStatus.loading));
    try {
      await _repository.createProject(event.payload);
      emit(state.copyWith(status: ProjectFormStatus.success));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(status: ProjectFormStatus.error, message: e.toString()),
      );
    }
  }

  Future<void> _onEditProject(
    EditProject event,
    Emitter<ProjectFormState> emit,
  ) async {
    emit(state.copyWith(status: ProjectFormStatus.loading));
    try {
      await _repository.updateProject(event.payload);
      emit(state.copyWith(status: ProjectFormStatus.success));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(
        state.copyWith(status: ProjectFormStatus.error, message: e.toString()),
      );
    }
  }

  Future<void> _onLoadAllProjectCategories(
    LoadAllProjectCategories event,
    Emitter<ProjectFormState> emit,
  ) async {
    try {
      final categories = await _repository.getAllCategory();
      emit(state.copyWith(projectCategories: categories));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
    }
  }
}
