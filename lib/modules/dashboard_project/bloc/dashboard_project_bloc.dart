import 'package:bloc_concurrency/bloc_concurrency.dart';
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
    on<LoadMoreProjectsEvent>(
      _onLoadMoreProjectEvent,
      transformer: droppable(),
    );
  }

  Future<void> _onLoadInitialProjectsEvent(
    LoadInitialProjectsEvent event,
    Emitter<DashboardProjectState> emit,
  ) async {
    emit(
      _updateTabState(
        currentState: state,
        type: event.tabType,
        newTabState: _getCurrentTabPagingState(
          event.tabType,
          state,
        ).copyWith(isFetchingInitial: true),
      ),
    );

    try {
      final newProjects = await _repository.getProjects(
        pages: 1,
        type: event.tabType.name,
      );

      final updatedTabState = _getCurrentTabPagingState(event.tabType, state)
          .copyWith(
            projects: newProjects,
            currentPage: 1,
            isFetchingMore: false,
            hasReachedMax: newProjects.isEmpty,
            isFetchingInitial: false,
          );

      final newState = _updateTabState(
        currentState: state,
        type: event.tabType,
        newTabState: updatedTabState,
      );

      emit(newState.copyWith(status: DashboardProjectStatus.success));
    } catch (e) {
      final currentTabState = _getCurrentTabPagingState(event.tabType, state);
      if (_getCurrentTabPagingState(event.tabType, state).projects.isEmpty) {
        emit(
          _updateTabState(
            currentState: state,
            type: event.tabType,
            message: e.toString(),
            status: DashboardProjectStatus.error,
            newTabState: currentTabState.copyWith(isFetchingInitial: false),
          ),
        );
      }
    }
  }

  Future<void> _onLoadMoreProjectEvent(
    LoadMoreProjectsEvent event,
    Emitter<DashboardProjectState> emit,
  ) async {
    final DashboardProjectTabPagingState currentTabState =
        _getCurrentTabPagingState(event.tabType, state);

    if (currentTabState.hasReachedMax || currentTabState.isFetchingMore) return;

    emit(
      _updateTabState(
        currentState: state,
        type: event.tabType,
        newTabState: currentTabState.copyWith(isFetchingMore: true),
      ),
    );
    try {
      final nextPage = currentTabState.currentPage + 1;
      final newProjects = await _repository.getProjects(
        pages: nextPage,
        type: event.tabType.name,
      );

      final updatedTabState = _getCurrentTabPagingState(event.tabType, state)
          .copyWith(
            projects: [
              ..._getCurrentTabPagingState(event.tabType, state).projects,
              ...newProjects,
            ],
            currentPage: nextPage,
            isFetchingMore: false,
            hasReachedMax: newProjects.isEmpty,
          );

      emit(
        _updateTabState(
          currentState: state,
          type: event.tabType,
          newTabState: updatedTabState,
        ),
      );
    } catch (e) {
      emit(
        _updateTabState(
          currentState: state,
          type: event.tabType,
          newTabState: _getCurrentTabPagingState(
            event.tabType,
            state,
          ).copyWith(isFetchingMore: false),
        ).copyWith(status: DashboardProjectStatus.error, message: e.toString()),
      );
    }
  }

  DashboardProjectState _updateTabState({
    required DashboardProjectState currentState,
    required DashboardProjectTabType type,
    DashboardProjectTabPagingState? newTabState,
    DashboardProjectStatus? status,
    String? message,
  }) {
    switch (type) {
      case DashboardProjectTabType.closest:
        return currentState.copyWith(
          closest: newTabState,
          status: status,
          message: message,
        );
      case DashboardProjectTabType.latest:
        return currentState.copyWith(
          latest: newTabState,
          status: status,
          message: message,
        );
      case DashboardProjectTabType.popular:
        return currentState.copyWith(
          popular: newTabState,
          status: status,
          message: message,
        );
    }
  }

  DashboardProjectTabPagingState _getCurrentTabPagingState(
    DashboardProjectTabType type,
    DashboardProjectState state,
  ) {
    switch (type) {
      case DashboardProjectTabType.closest:
        return state.closest;
      case DashboardProjectTabType.latest:
        return state.latest;
      case DashboardProjectTabType.popular:
        return state.popular;
    }
  }
}
