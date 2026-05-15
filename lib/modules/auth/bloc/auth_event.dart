import 'package:equatable/equatable.dart';

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
  final String name;
  final String email;
  final String passowrd1;
  final String passowrd2;
  final String? gender;
  final String accountType;
  final double latitude;
  final double longitude;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.passowrd1,
    required this.passowrd2,
    this.gender,
    required this.accountType,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        passowrd1,
        passowrd2,
        gender,
        accountType,
        latitude,
        longitude,
      ];
}

class AuthLogoutRequested extends AuthEvent {
  final String refreshToken;

  const AuthLogoutRequested(this.refreshToken);

  @override
  List<Object?> get props => [refreshToken];
}

class AuthCheckRequested extends AuthEvent {}
