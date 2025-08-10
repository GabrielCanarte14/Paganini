part of 'methods_bloc.dart';

sealed class MethodsState extends Equatable {
  const MethodsState();

  @override
  List<Object> get props => [];
}

class Empty extends MethodsState {}

class Checking extends MethodsState {}

class Complete extends MethodsState {
  final List<dynamic> metodos;

  const Complete({this.metodos = const []});

  @override
  List<Object> get props => [metodos];
}

final class MethodsInitial extends MethodsState {}

class MethodsError extends MethodsState {
  final String message;
  const MethodsError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
