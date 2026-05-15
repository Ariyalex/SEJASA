import 'package:equatable/equatable.dart';

class SkillEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  const SkillEntity({required this.id, required this.name, this.description});

  @override
  List<Object?> get props => [id, name, description];
}
