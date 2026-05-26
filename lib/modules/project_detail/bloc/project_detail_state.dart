import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/project_entity.dart';

enum ProjectDetailStatus { initial, loading, success, error, applyLoading, applySuccess, applyError }

class ProjectDetailState extends Equatable {
  final ProjectEntity? project;
  final ProjectDetailStatus status;
  final String? message;
  final bool isAuthenticated;
  final String? appliedChatId;
  final String? appliedProjectId;

  const ProjectDetailState({
    this.project,
    this.status = ProjectDetailStatus.initial,
    this.message,
    this.isAuthenticated = false,
    this.appliedChatId,
    this.appliedProjectId,
  });

  ProjectDetailState copyWith({
    final ProjectEntity? project,
    final ProjectDetailStatus? status,
    final String? message,
    final bool? isAuthenticated,
    final String? appliedChatId,
    final String? appliedProjectId,
  }) {
    return ProjectDetailState(
      project: project ?? this.project,
      status: status ?? this.status,
      message: message ?? this.message,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      appliedChatId: appliedChatId ?? this.appliedChatId,
      appliedProjectId: appliedProjectId ?? this.appliedProjectId,
    );
  }

  @override
  List<Object?> get props => [
        project,
        status,
        message,
        isAuthenticated,
        appliedChatId,
        appliedProjectId,
      ];
}
