import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchStarted extends SearchEvent {}

class SearchKeywordChanged extends SearchEvent {
  final String keyword;
  const SearchKeywordChanged(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class SearchTypeChanged extends SearchEvent {
  final bool isProject;
  const SearchTypeChanged(this.isProject);

  @override
  List<Object?> get props => [isProject];
}

class PerformSearch extends SearchEvent {
  final String keyword;
  const PerformSearch(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class AddHistory extends SearchEvent {
  final String keyword;
  const AddHistory(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class ClearHistory extends SearchEvent {}

class ApplyProjectFilter extends SearchEvent {
  final String? sort;
  final ProjectStatus? status;
  final String? category;

  const ApplyProjectFilter({this.sort, this.status, this.category});

  @override
  List<Object?> get props => [sort, status, category];
}
