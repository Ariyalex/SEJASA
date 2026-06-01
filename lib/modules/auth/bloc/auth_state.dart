import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  success,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? message;

  const AuthState({this.status = AuthStatus.initial, this.user, this.message});

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? message,
    bool clearMessage = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
