import 'package:equatable/equatable.dart';

enum ProjectFormStatus { initial, loading, success, error }

class ProjectFormState extends Equatable {
  final ProjectFormStatus status;
  final String? message;
  const ProjectFormState({
    this.status = ProjectFormStatus.initial,
    this.message,
  });

  ProjectFormState copyWith({
    final ProjectFormStatus? status,
    final String? message,
  }) {
    return ProjectFormState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
