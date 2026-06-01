import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/data/payloads/profile_update_payload.dart';
import 'package:sejasa/data/payloads/register_payload.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final RegisterPayload payload;

  const AuthRegisterRequested(this.payload);

  @override
  List<Object?> get props => [payload];
}

class AuthLogoutRequested extends AuthEvent {
  final String refreshToken;

  const AuthLogoutRequested(this.refreshToken);

  @override
  List<Object?> get props => [refreshToken];
}

class AuthCheckRequested extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final UserEntity user;
  const AuthUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthProfileRefreshed extends AuthEvent {}

class AuthProfileUpdateRequested extends AuthEvent {
  final UserUpdatePayload payload;
  const AuthProfileUpdateRequested(this.payload);

  @override
  List<Object?> get props => [payload];
}

class AuthSkillAddRequested extends AuthEvent {
  final String name;
  const AuthSkillAddRequested(this.name);

  @override
  List<Object?> get props => [name];
}

class AuthSkillEditRequested extends AuthEvent {
  final String skillId;
  final String name;
  const AuthSkillEditRequested(this.skillId, this.name);

  @override
  List<Object?> get props => [skillId, name];
}

class AuthSkillDeleteRequested extends AuthEvent {
  final String skillId;
  const AuthSkillDeleteRequested(this.skillId);

  @override
  List<Object?> get props => [skillId];
}
