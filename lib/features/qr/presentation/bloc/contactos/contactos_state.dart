part of 'contactos_bloc.dart';

sealed class ContactosState extends Equatable {
  const ContactosState();

  @override
  List<Object> get props => [];
}

class Checking extends ContactosState {}

class Complete extends ContactosState {
  final List<ContactModel> contactos;

  const Complete({this.contactos = const []});

  @override
  List<Object> get props => [contactos];
}

class Agregado extends ContactosState {
  final ContactModel? contacto;

  const Agregado({this.contacto});
}

final class ContactoInitial extends ContactosState {}

class ContactoElimindo extends ContactosState {
  final String message;

  const ContactoElimindo({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ContactoError extends ContactosState {
  final String message;

  const ContactoError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
