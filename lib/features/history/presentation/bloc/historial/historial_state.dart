part of 'historial_bloc.dart';

sealed class HistorialState extends Equatable {
  const HistorialState();

  @override
  List<Object> get props => [];
}

class Empty extends HistorialState {}

class Consultando extends HistorialState {}

class Completo extends HistorialState {
  final List<dynamic> historial;

  const Completo({this.historial = const []});

  @override
  List<Object> get props => [historial];
}

final class MethodsInitial extends HistorialState {}

class HistorialError extends HistorialState {
  final String message;
  const HistorialError({required this.message});

  @override
  List<Object> get props => [message];
}
