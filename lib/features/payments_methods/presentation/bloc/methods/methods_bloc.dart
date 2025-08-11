// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/features/payments_methods/domain/usecases/delete_payment_method.dart';
import 'package:paganini_wallet/features/payments_methods/domain/usecases/register_bank_account.dart';
import 'package:paganini_wallet/features/payments_methods/domain/usecases/register_card.dart';
import '../../../../../core/error/failures.dart';
import '../../../../shared/data/services/services.dart';
import '../../../domain/usecases/usecases.dart';

part 'methods_event.dart';
part 'methods_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class MethodsBloc extends Bloc<MethodsEvent, MethodsState> {
  final GetMethods getMethodsUseCase;
  final RegisterCard registerCardUseCase;
  final RegisterbankAccount registerbankAccount;
  final DeletePaymentMethod deletePaymentMethod;
  final KeyValueStorageServiceImpl keyValueStorageService;

  MethodsBloc(
      {required this.getMethodsUseCase,
      required this.registerCardUseCase,
      required this.registerbankAccount,
      required this.deletePaymentMethod,
      required this.keyValueStorageService})
      : super(MethodsInitial()) {
    on<GetMethodsEvent>(_onGetMethodsRequested);
    on<RegisterCardEvent>(_onRegisterCard);
    on<RegisterBankEvent>(_onRegisterBankAccount);
    on<DeletePaymentEvent>(_onDeletePaymentMethod);
  }

  Future<void> _onGetMethodsRequested(
      GetMethodsEvent event, Emitter<MethodsState> emit) async {
    emit(Checking());
    final failureOrMetodos =
        await getMethodsUseCase(Params(email: event.email));
    await failureOrMetodos.fold((failure) {
      emit(MethodsError(message: _mapFailureToMessage(failure)));
    }, (metodos) async {
      emit(Complete(metodos: metodos));
    });
  }

  Future<void> _onRegisterCard(
      RegisterCardEvent event, Emitter<MethodsState> emit) async {
    emit(Checking());
    final failureOrMessage = await registerCardUseCase(CardParams(
        number: event.number,
        titular: event.titular,
        month: event.month,
        year: event.year,
        cvv: event.cvv,
        type: event.type,
        red: event.red));
    await failureOrMessage.fold((failure) {
      emit(MethodsError(message: _mapFailureToMessage(failure)));
    }, (message) async {
      emit(Agregado(message: message));
    });
  }

  Future<void> _onRegisterBankAccount(
      RegisterBankEvent event, Emitter<MethodsState> emit) async {
    emit(Checking());
    final failureOrMessage = await registerbankAccount(BankParams(
        number: event.number,
        bank: event.bank,
        identificacion: event.identificacion,
        titular: event.titular,
        type: event.type));
    await failureOrMessage.fold((failure) {
      emit(MethodsError(message: _mapFailureToMessage(failure)));
    }, (message) async {
      emit(Agregado(message: message));
    });
  }

  Future<void> _onDeletePaymentMethod(
      DeletePaymentEvent event, Emitter<MethodsState> emit) async {
    emit(Checking());
    final failureOrMessage =
        await deletePaymentMethod(DeleteParams(id: event.id));
    await failureOrMessage.fold((failure) {
      emit(MethodsError(message: _mapFailureToMessage(failure)));
    }, (message) async {
      emit(Agregado(message: message));
    });
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
