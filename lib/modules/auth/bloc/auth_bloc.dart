import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthBloc(this._authRepository, this._storageService) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storageService.read('access_token');
    if (token == null || token.isEmpty) {
      emit(AuthUnauthenticated());
      return;
    }

    emit(AuthLoading());
    try {
      final user = await _authRepository.getMyProfile();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(event.email, event.password);
      final user = await _authRepository.getMyProfile();
      emit(AuthAuthenticated(user));
      emit(const AuthSuccess("Login Berhasil"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.register(event.payload);
      emit(const AuthSuccess("Registrasi Berhasil"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout(event.refreshToken);
      await _storageService.delete('access_token');
      await _storageService.delete('refresh_token');
      emit(AuthUnauthenticated());
      emit(const AuthSuccess("Logout Berhasil"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
