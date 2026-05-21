import 'package:equatable/equatable.dart';
import 'package:sejasa/data/models/user_model.dart';
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
  final UserModel user;
  const AuthUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthProfileRefreshed extends AuthEvent {}
