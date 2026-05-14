import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_event.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_state.dart';
import 'package:sejasa/data/value_objects/project_filter_type.dart';

class ProfilProjectBloc extends Bloc<ProfilProjectEvent, ProfilProjectState> {
  final ProjectRepository _repository;
  late final StreamSubscription<void> _projectUpdateSubscription;
  ProfilProjectBloc(this._repository) : super(ProfilProjectState()) {
    on<LoadMyTakenProjects>(_onLoadTakenProject);
    on<LoadMyUploadedProjects>(_onLoadUploadedProject);

    _projectUpdateSubscription = _repository.projectUpdateStream.listen((
      event,
    ) {
      add(LoadMyTakenProjects());
    });
  }

  Future<void> _onLoadUploadedProject(
    LoadMyUploadedProjects event,
    Emitter<ProfilProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectUploaded: true));
    try {
      final projects = await _repository.getMyProjects();
      emit(
        state.copyWith(
          uploadedProjects: projects,
          status: ProfilProjectStatus.success,
          isFetchingProjectUploaded: false,
        ),
      );
    } catch (e) {
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
    LoadMyTakenProjects event,
    Emitter<ProfilProjectState> emit,
  ) async {
    emit(state.copyWith(isFetchingProjectTaken: true));
    try {
      final projects = await _repository.getMyProjects();
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
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: ProfilProjectStatus.error,
          isFetchingProjectTaken: false,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _projectUpdateSubscription.cancel();
    return super.close();
  }
}
