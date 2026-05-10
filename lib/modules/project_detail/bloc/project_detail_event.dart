import 'package:equatable/equatable.dart';

class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProject extends ProjectDetailEvent {
  final String id;
  const LoadProject(this.id);

  @override
  List<Object?> get props => [id];
}
