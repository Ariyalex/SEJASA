import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/repositories/user_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProjectRepository projectRepository;
  final UserRepository userRepository;
  final StorageService storageService;

  static const String _historyKey = 'search_history';

  SearchBloc({
    required this.projectRepository,
    required this.userRepository,
    required this.storageService,
  }) : super(const SearchState()) {
    on<SearchStarted>(_onSearchStarted);
    on<SearchKeywordChanged>(_onSearchKeywordChanged);
    on<SearchTypeChanged>(_onSearchTypeChanged);
    on<PerformSearch>(_onPerformSearch);
    on<AddHistory>(_onAddHistory);
    on<ClearHistory>(_onClearHistory);
    on<ApplyProjectFilter>(_onApplyProjectFilter);
  }

  Future<void> _onSearchStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    final history = await storageService.readStringList(_historyKey);
    if (history != null) {
      emit(state.copyWith(history: history));
    }
  }

  void _onSearchKeywordChanged(
    SearchKeywordChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(lastKeyword: event.keyword));
  }

  void _onSearchTypeChanged(
    SearchTypeChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      isProject: event.isProject,
      projectResults: [],
      userResults: [],
      status: SearchStatus.initial,
    ));
  }

  Future<void> _onPerformSearch(
    PerformSearch event,
    Emitter<SearchState> emit,
  ) async {
    if (event.keyword.isEmpty) return;

    emit(state.copyWith(status: SearchStatus.loading, lastKeyword: event.keyword));

    try {
      if (state.isProject) {
        final results = await projectRepository.searchProjects(
          keyword: event.keyword,
          sort: state.selectedSort,
          status: state.selectedStatus,
          category: state.selectedCategory,
        );
        emit(state.copyWith(
          status: SearchStatus.success,
          projectResults: results,
        ));
      } else {
        final results = await userRepository.searchUsers(event.keyword);
        emit(state.copyWith(
          status: SearchStatus.success,
          userResults: results,
        ));
      }

      add(AddHistory(event.keyword));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddHistory(
    AddHistory event,
    Emitter<SearchState> emit,
  ) async {
    final currentHistory = List<String>.from(state.history);
    
    // Remove if already exists to move it to the top
    currentHistory.remove(event.keyword);
    currentHistory.insert(0, event.keyword);

    // Limit history size (e.g., 10)
    if (currentHistory.length > 10) {
      currentHistory.removeLast();
    }

    await storageService.writeStringList(_historyKey, currentHistory);
    emit(state.copyWith(history: currentHistory));
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<SearchState> emit,
  ) async {
    await storageService.delete(_historyKey);
    emit(state.copyWith(history: []));
  }

  void _onApplyProjectFilter(
    ApplyProjectFilter event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      selectedSort: event.sort,
      selectedStatus: event.status,
      selectedCategory: event.category,
    ));

    if (state.lastKeyword.isNotEmpty) {
      add(PerformSearch(state.lastKeyword));
    }
  }
}
