// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/auth/data/model/models.dart';
import 'package:paganini_wallet/features/auth/domain/entities/entities.dart';

import '../../../../../core/error/failures.dart';
import '../../../../shared/data/services/services.dart';
import '../../../domain/usecases/usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final RegisterUser registerUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final GetUserData getUserData;
  final ResetPasswordUseCase resetPasswordUseCase;
  final KeyValueStorageServiceImpl keyValueStorageService;

  Timer? _expiryTimer;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUserUseCase,
    required this.forgotPasswordUseCase,
    required this.getUserData,
    required this.resetPasswordUseCase,
    required this.keyValueStorageService,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginRequested);
    on<LogoutEvent>(_onLogoutRequested);
    on<RegisterEvent>(_onRegisterRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<GetUserDataEvent>(_onGetUserData);
    on<SessionStartedEvent>(_onSessionStarted);
    on<SessionExpiredEvent>(_onSessionExpired);
  }

  Future<void> _onLoginRequested(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(Comprobando());
    final failureOrUser = await loginUseCase(
        Params(username: event.username, password: event.password));
    await failureOrUser!.fold((failure) {
      emit(UserError(message: _mapFailureToMessage(failure)));
    }, (user) async {
      final expiresAt = DateTime.now().add(const Duration(minutes: 14));
      await keyValueStorageService.setKeyValue(
          'expiresAt', expiresAt.toIso8601String());
      add(SessionStartedEvent(expiresAt: expiresAt));
    });
  }

  Future<void> _onRegisterRequested(
      RegisterEvent event, Emitter<AuthState> emit) async {
    emit(Registering());
    final failureOrUser = await registerUserUseCase(RegisterParams(
      name: event.name,
      lastname: event.lastname,
      email: event.email,
      phone: event.phone,
      password: event.password,
    ));
    await failureOrUser!.fold((failure) {
      emit(UserError(message: failure.errorMessage));
    }, (mensaje) async {
      emit(Register(mensaje: mensaje));
    });
  }

  Future<void> _onLogoutRequested(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(Comprobando());
    _expiryTimer?.cancel();
    _expiryTimer = null;
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('expiresAt');
    await Hive.box('UserModel').clear();
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(Comprobando());
    final token = await keyValueStorageService.getValue<String>('token');
    final username = await keyValueStorageService.getValue<String>('username');
    final password = await keyValueStorageService.getValue<String>('password');
    final expiresAtIso =
        await keyValueStorageService.getValue<String>('expiresAt');

    if (token == null ||
        username == null ||
        password == null ||
        token.trim().isEmpty ||
        username.trim().isEmpty ||
        password.trim().isEmpty) {
      add(const LogoutEvent());
      return;
    }

    if (expiresAtIso == null || expiresAtIso.isEmpty) {
      add(const LogoutEvent());
      return;
    }

    final expiresAt = DateTime.tryParse(expiresAtIso);
    if (expiresAt == null || DateTime.now().isAfter(expiresAt)) {
      add(const LogoutEvent());
      return;
    }

    add(SessionStartedEvent(expiresAt: expiresAt));
  }

  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(Comprobando());
    final failureOrUser =
        await forgotPasswordUseCase(ForgotParams(email: event.email));
    failureOrUser?.fold(
      (failure) {
        emit(UserError(message: failure.errorMessage));
      },
      (mensaje) {
        emit(Aprovado(mensaje: mensaje));
      },
    );
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(Comprobando());
    final failureOrUser = await resetPasswordUseCase(ResetParams(
        email: event.email, codigo: event.codigo, password: event.password));
    failureOrUser?.fold(
      (failure) {
        emit(UserError(message: failure.errorMessage));
      },
      (mensaje) {
        emit(Actualizado(mensaje: mensaje));
      },
    );
  }

  Future<void> _onGetUserData(
      GetUserDataEvent event, Emitter<AuthState> emit) async {
    emit(GetInfo());
    final failureOrUser = await getUserData(NoParams());
    failureOrUser.fold((failure) {
      emit(UserError(message: failure.errorMessage));
    }, (user) async {
      emit(UserInfo(user: user));
    });
  }

  Future<void> _onSessionStarted(
      SessionStartedEvent event, Emitter<AuthState> emit) async {
    _expiryTimer?.cancel();
    final now = DateTime.now();
    final duration = event.expiresAt.difference(now);
    final safe = duration.isNegative ? Duration.zero : duration;
    _expiryTimer = Timer(safe, () => add(SessionExpiredEvent()));
    emit(Authenticated(mensaje: 'Sesión iniciada', expiresAt: event.expiresAt));
  }

  Future<void> _onSessionExpired(
      SessionExpiredEvent event, Emitter<AuthState> emit) async {
    _expiryTimer?.cancel();
    _expiryTimer = null;
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('expiresAt');
    await Hive.box('UserModel').clear();
    emit(Unauthenticated());
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is DioFailure) {
      return failure.errorMessage;
    } else if (failure is ServerFailure) {
      return failure.errorMessage;
    } else if (failure is CacheFailure) {
      return CACHE_FAILURE_MESSAGE;
    } else {
      return 'Unexpected error';
    }
  }

  @override
  Future<void> close() {
    _expiryTimer?.cancel();
    return super.close();
  }
}
