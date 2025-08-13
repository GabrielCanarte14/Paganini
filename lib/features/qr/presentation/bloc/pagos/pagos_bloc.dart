// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/features/qr/domain/usecases/payment.dart';
import '../../../../../core/error/failures.dart';
import '../../../../shared/data/services/services.dart';
part 'pagos_event.dart';
part 'pagos_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PagosBloc extends Bloc<PagosEvent, PagosState> {
  final Payment paymentUseCase;
  final KeyValueStorageServiceImpl keyValueStorageService;

  PagosBloc(
      {required this.paymentUseCase, required this.keyValueStorageService})
      : super(PaymentInitial()) {
    on<PaymentEvent>(_onPaymentRequested);
  }

  Future<void> _onPaymentRequested(
      PaymentEvent event, Emitter<PagosState> emit) async {
    emit(Revisando());
    final failureOrMessage = await paymentUseCase(
        PaymentParams(correo: event.correo, amount: event.monto));
    await failureOrMessage.fold((failure) {
      emit(PaymentError(message: _mapFailureToMessage(failure)));
    }, (message) async {
      emit(PaymentComplete(message: message));
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
