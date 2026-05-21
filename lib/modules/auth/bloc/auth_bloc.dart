import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/domain/repositories/auth_repository.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthBloc(this._authRepository, this._storageService) : super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserUpdated>(_onUserUpdated);
    on<AuthProfileRefreshed>(_onProfileRefreshed);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storageService.read('access_token');
    if (token == null || token.isEmpty) {
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    try {
      final user = await _authRepository.getMyProfile();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    try {
      await _authRepository.login(event.email, event.password);
      final user = await _authRepository.getMyProfile();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      emit(state.copyWith(status: AuthStatus.success, message: "Login Berhasil"));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    try {
      await _authRepository.register(event.payload);
      emit(state.copyWith(status: AuthStatus.success, message: "Registrasi Berhasil"));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    try {
      await _authRepository.logout(event.refreshToken);
      await _storageService.delete('access_token');
      await _storageService.delete('refresh_token');
      emit(state.copyWith(status: AuthStatus.unauthenticated, clearUser: true));
      emit(state.copyWith(status: AuthStatus.success, message: "Logout Berhasil"));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  void _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(status: AuthStatus.authenticated, user: event.user));
  }

  Future<void> _onProfileRefreshed(
    AuthProfileRefreshed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getMyProfile();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e, stackTrace) {
      LogUtils.e(e.toString(), e, stackTrace);
    }
  }
}
