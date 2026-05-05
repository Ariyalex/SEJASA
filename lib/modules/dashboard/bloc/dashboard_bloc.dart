import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/data/repositories/project_repository.dart';
import 'package:sejasa/modules/dashboard/bloc/dashboard_event.dart';
import 'package:sejasa/modules/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ProjectRepository _repository;
  DashboardBloc(this._repository) : super(const DashboardState()) {
    on<LoadProjects>(_onLoadProjects);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final projects = await _repository.getProjects();
      emit(state.copyWith(projects: projects, status: DashboardStatus.success));
    } catch (e) {
      emit(
        state.copyWith(message: e.toString(), status: DashboardStatus.error),
      );
    }
  }
}
