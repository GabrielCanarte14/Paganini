// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  final KeyValueStorageServiceImpl keyValueStorageService;

  AuthBloc(
      {required this.loginUseCase,
      required this.logoutUseCase,
      required this.registerUserUseCase,
      required this.keyValueStorageService})
      : super(AuthInitial()) {
    on<LoginEvent>(_onLoginRequested);
    on<LogoutEvent>(_onLogoutRequested);
    on<RegisterEvent>(_onRegisterRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(Checking());
    final failureOrUser = await loginUseCase(
        Params(username: event.username, password: event.password));
    await failureOrUser!.fold((failure) {
      emit(UserError(message: _mapFailureToMessage(failure)));
    }, (user) async {
      emit(Authenticated());
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
        password: event.password));
    await failureOrUser!.fold((failure) {
      emit(UserError(message: failure.errorMessage));
    }, (mensaje) async {
      emit(Register(mensaje: mensaje));
    });
  }

  Future<void> _onLogoutRequested(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(Checking());
    if (event.user == null) {
      emit(Unauthenticated());
      await keyValueStorageService.removeKey('token');
      await Hive.box('UserModel').clear();
      return;
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(Checking());

    final token = await keyValueStorageService.getValue<String>('token');
    final username = await keyValueStorageService.getValue<String>('username');
    final password = await keyValueStorageService.getValue<String>('password');

    if (token == null ||
        username == null ||
        password == null ||
        token.trim().isEmpty ||
        username.trim().isEmpty ||
        password.trim().isEmpty) {
      add(const LogoutEvent());
    } else {
      add(LoginEvent(username: username, password: password));
    }
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
}
