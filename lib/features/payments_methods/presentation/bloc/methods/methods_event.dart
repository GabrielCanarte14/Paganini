part of 'methods_bloc.dart';

sealed class MethodsEvent extends Equatable {
  const MethodsEvent();

  @override
  List<Object> get props => [];
}

class GetMethodsEvent extends MethodsEvent {
  final String email;

  const GetMethodsEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}
