// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../../shared/data/services/services.dart';
import '../../../domain/usecases/usecases.dart';

part 'methods_event.dart';
part 'methods_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class MethodsBloc extends Bloc<MethodsEvent, MethodsState> {
  final GetMethods getMethodsUseCase;
  final KeyValueStorageServiceImpl keyValueStorageService;

  MethodsBloc(
      {required this.getMethodsUseCase, required this.keyValueStorageService})
      : super(MethodsInitial()) {
    on<GetMethodsEvent>(_onGetMethodsRequested);
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
