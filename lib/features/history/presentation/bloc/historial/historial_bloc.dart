// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import '../../../../../core/error/failures.dart';
import '../../../../shared/data/services/services.dart';
import '../../../domain/usecases/usecases.dart';

part 'historial_event.dart';
part 'historial_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class HistorialBloc extends Bloc<HistorialEvent, HistorialState> {
  final GetHistory getHistorialUseCase;
  final KeyValueStorageServiceImpl keyValueStorageService;

  HistorialBloc(
      {required this.getHistorialUseCase, required this.keyValueStorageService})
      : super(MethodsInitial()) {
    on<GetHistorialEvent>(_onGetHistorialRequested);
  }

  Future<void> _onGetHistorialRequested(
      GetHistorialEvent event, Emitter<HistorialState> emit) async {
    emit(Checking());
    final failureOrHistorial = await getHistorialUseCase(NoParams());
    await failureOrHistorial.fold((failure) {
      emit(HistorialError(message: _mapFailureToMessage(failure)));
    }, (historial) async {
      emit(Complete(historial: historial));
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
