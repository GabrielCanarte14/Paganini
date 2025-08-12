part of 'contactos_bloc.dart';

sealed class ContactosEvent extends Equatable {
  const ContactosEvent();

  @override
  List<Object> get props => [];
}

class GetContactosEvent extends ContactosEvent {}

class RegisterContactoEvent extends ContactosEvent {
  final String correo;

  const RegisterContactoEvent({required this.correo});
}

class DeleteContactoEvent extends ContactosEvent {
  final String correo;

  const DeleteContactoEvent({required this.correo});
}
