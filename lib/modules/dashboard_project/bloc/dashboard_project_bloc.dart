import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
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
    on<UpdateDashboardLocationEvent>(_onUpdateDashboardLocationEvent);
  }

  Future<void> _onUpdateDashboardLocationEvent(
    UpdateDashboardLocationEvent event,
    Emitter<DashboardProjectState> emit,
  ) async {
    emit(
      state.copyWith(
        latitude: event.latitude,
        longitude: event.longitude,
        address: event.address,
      ),
    );

    // Refresh the closest tab when location changes
    add(
      LoadInitialProjectsEvent(
        tabType: DashboardProjectTabType.closest,
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );
  }

  Future<void> _onLoadInitialProjectsEvent(
    LoadInitialProjectsEvent event,
    Emitter<DashboardProjectState> emit,
  ) async {
    // If it's closest tab and we don't have coordinates in event or state, we can't fetch yet
    if (event.tabType == DashboardProjectTabType.closest &&
        event.latitude == null &&
        state.latitude == null) {
      return;
    }

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
      final result = await _getProjectsByTabType(
        event.tabType,
        1,
        10,
        event.latitude,
        event.longitude,
      );

      final updatedTabState = _getCurrentTabPagingState(event.tabType, state)
          .copyWith(
            projects: result.data,
            currentPage: result.meta.currentPage,
            isFetchingMore: false,
            hasReachedMax: result.meta.currentPage >= result.meta.totalPages,
            isFetchingInitial: false,
          );

      final newState = _updateTabState(
        currentState: state,
        type: event.tabType,
        newTabState: updatedTabState,
      );

      emit(newState.copyWith(status: DashboardProjectStatus.success));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
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
      final result = await _getProjectsByTabType(
        event.tabType,
        nextPage,
        10,
        event.latitude,
        event.longitude,
      );

      final currentTab = _getCurrentTabPagingState(event.tabType, state);

      final updatedTabState = currentTab.copyWith(
        projects: [...currentTab.projects, ...result.data],
        currentPage: result.meta.currentPage,
        isFetchingMore: false,
        hasReachedMax: result.meta.currentPage >= result.meta.totalPages,
      );

      emit(
        _updateTabState(
          currentState: state,
          type: event.tabType,
          newTabState: updatedTabState,
        ),
      );
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
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

  Future<PaginatedResult<ProjectEntity>> _getProjectsByTabType(
    DashboardProjectTabType type,
    int page,
    int limit,
    double? latitude,
    double? longitude,
  ) async {
    switch (type) {
      case DashboardProjectTabType.closest:
        final lat = latitude ?? state.latitude;
        final lon = longitude ?? state.longitude;

        if (lat == null || lon == null) {
          throw Exception("Lokasi tidak ditentukan untuk pencarian terdekat");
        }

        return await _repository.getNearestProjects(page, limit, lat, lon);
      case DashboardProjectTabType.latest:
        return await _repository.getNewestProjects(page, limit);
      case DashboardProjectTabType.popular:
        //sementara gini dulu, nuggu dari be perbaikan
        return await _repository.getPopularProjects(page, limit);
    }
  }
}
