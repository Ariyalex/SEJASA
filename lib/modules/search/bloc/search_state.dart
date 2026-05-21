import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/entities/user_entity.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final bool isProject;
  final List<String> history;
  final List<ProjectEntity> projectResults;
  final List<UserEntity> userResults;
  final String? errorMessage;
  final String? selectedSort;
  final ProjectStatus? selectedStatus;
  final String? selectedCategory;
  final String lastKeyword;

  const SearchState({
    this.status = SearchStatus.initial,
    this.isProject = true,
    this.history = const [],
    this.projectResults = const [],
    this.userResults = const [],
    this.errorMessage,
    this.selectedSort,
    this.selectedStatus,
    this.selectedCategory,
    this.lastKeyword = '',
  });

  SearchState copyWith({
    SearchStatus? status,
    bool? isProject,
    List<String>? history,
    List<ProjectEntity>? projectResults,
    List<UserEntity>? userResults,
    String? errorMessage,
    String? selectedSort,
    ProjectStatus? selectedStatus,
    String? selectedCategory,
    String? lastKeyword,
  }) {
    return SearchState(
      status: status ?? this.status,
      isProject: isProject ?? this.isProject,
      history: history ?? this.history,
      projectResults: projectResults ?? this.projectResults,
      userResults: userResults ?? this.userResults,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedSort: selectedSort ?? this.selectedSort,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      lastKeyword: lastKeyword ?? this.lastKeyword,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isProject,
    history,
    projectResults,
    userResults,
    errorMessage,
    selectedSort,
    selectedStatus,
    selectedCategory,
    lastKeyword,
  ];
}
