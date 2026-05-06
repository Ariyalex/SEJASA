import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/data/repositories/project_repository.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_event.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_state.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_tab_paging_state.dart';

class DashboardProjectBloc
    extends Bloc<DashboardProjectEvent, DashboardProjectState> {
  final ProjectRepository _repository;
  DashboardProjectBloc(this._repository)
    : super(const DashboardProjectState()) {
    on<LoadInitialProjectsEvent>(_onLoadInitialProjectsEvent);
    on<LoadMoreProjectsEvent>(_onLoadMoreProjectEvent);
  }

  Future<void> _onLoadInitialProjectsEvent(
    LoadInitialProjectsEvent event,
    Emitter<DashboardProjectState> emit,
  ) async {
    final DashboardProjectTabPagingState currentTabState;
    switch (event.tabType) {
      case DashboardProjectTabType.closest:
        currentTabState = state.closest;
        break;
      case DashboardProjectTabType.latest:
        currentTabState = state.latest;
        break;
      case DashboardProjectTabType.popular:
        currentTabState = state.popular;
        break;
    }

    emit(
      _updateTabState(
        state,
        event.tabType,
        currentTabState.copyWith(isFetchingInitial: true),
      ),
    );

    try {
      final newProjects = await _repository.getProjects(
        pages: 1,
        type: event.tabType.name,
      );

      final updatedTabState = currentTabState.copyWith(
        projects: newProjects,
        currentPage: 1,
        isFetchingMore: false,
        hasReachedMax: newProjects.isEmpty,
        isFetchingInitial: false,
      );

      final newState = _updateTabState(state, event.tabType, updatedTabState);

      emit(newState.copyWith(status: DashboardProjectStatus.success));
    } catch (e) {
      if (currentTabState.projects.isEmpty) {
        emit(
          state.copyWith(
            message: e.toString(),
            status: DashboardProjectStatus.error,
          ),
        );
      }
    }
  }

  Future<void> _onLoadMoreProjectEvent(
    LoadMoreProjectsEvent event,
    Emitter<DashboardProjectState> emit,
  ) async {
    final DashboardProjectTabPagingState currentTabState;
    switch (event.tabType) {
      case DashboardProjectTabType.closest:
        currentTabState = state.closest;
        break;
      case DashboardProjectTabType.latest:
        currentTabState = state.latest;
        break;
      case DashboardProjectTabType.popular:
        currentTabState = state.popular;
        break;
    }

    if (currentTabState.hasReachedMax || currentTabState.isFetchingMore) return;

    emit(
      _updateTabState(
        state,
        event.tabType,
        currentTabState.copyWith(isFetchingMore: true),
      ),
    );
    try {
      final nextPage = currentTabState.currentPage + 1;
      final newProjects = await _repository.getProjects(
        pages: nextPage,
        type: event.tabType.name,
      );

      final updatedTabState = currentTabState.copyWith(
        projects: [...currentTabState.projects, ...newProjects],
        currentPage: nextPage,
        isFetchingMore: false,
        hasReachedMax: newProjects.isEmpty,
      );

      emit(_updateTabState(state, event.tabType, updatedTabState));
    } catch (e) {
      emit(
        _updateTabState(
          state,
          event.tabType,
          currentTabState.copyWith(isFetchingMore: false),
        ).copyWith(status: DashboardProjectStatus.error, message: e.toString()),
      );
    }
  }

  DashboardProjectState _updateTabState(
    DashboardProjectState currentState,
    DashboardProjectTabType type,
    DashboardProjectTabPagingState newTabState,
  ) {
    switch (type) {
      case DashboardProjectTabType.closest:
        return currentState.copyWith(closest: newTabState);
      case DashboardProjectTabType.latest:
        return currentState.copyWith(latest: newTabState);
      case DashboardProjectTabType.popular:
        return currentState.copyWith(popular: newTabState);
    }
  }
}
