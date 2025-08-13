// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/data/model/models.dart';
import '../../../../../core/error/failures.dart';
import '../../../../shared/data/services/services.dart';
import '../../../domain/usecases/usecases.dart';

part 'contactos_event.dart';
part 'contactos_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class ContactosBloc extends Bloc<ContactosEvent, ContactosState> {
  final GetContacts getContactosUseCase;
  final RegisterContact registerContactoUseCase;
  final DeleteContact deleteContacto;
  final KeyValueStorageServiceImpl keyValueStorageService;

  ContactosBloc(
      {required this.getContactosUseCase,
      required this.registerContactoUseCase,
      required this.deleteContacto,
      required this.keyValueStorageService})
      : super(ContactoInitial()) {
    on<GetContactosEvent>(_onGetContactosRequested);
    on<RegisterContactoEvent>(_onRegisterContacto);
    on<DeleteContactoEvent>(_onDeleteContacto);
  }

  Future<void> _onGetContactosRequested(
      GetContactosEvent event, Emitter<ContactosState> emit) async {
    emit(Checking());
    final failureOrContactos = await getContactosUseCase(NoParams());
    await failureOrContactos.fold((failure) {
      emit(ContactoError(message: _mapFailureToMessage(failure)));
    }, (contactos) async {
      emit(Complete(contactos: contactos));
    });
  }

  Future<void> _onRegisterContacto(
      RegisterContactoEvent event, Emitter<ContactosState> emit) async {
    emit(Checking());
    final failureOrContacto =
        await registerContactoUseCase(ContactParams(correo: event.correo));
    await failureOrContacto.fold((failure) {
      emit(ContactoError(message: _mapFailureToMessage(failure)));
    }, (contacto) async {
      emit(Agregado(contacto: contacto));
    });
  }

  Future<void> _onDeleteContacto(
      DeleteContactoEvent event, Emitter<ContactosState> emit) async {
    emit(Checking());
    final failureOrMessage =
        await deleteContacto(DeleteContactParams(correo: event.correo));
    await failureOrMessage.fold((failure) {
      emit(ContactoError(message: _mapFailureToMessage(failure)));
    }, (message) async {
      emit(ContactoElimindo(message: message));
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
