part of 'historial_bloc.dart';

sealed class HistorialEvent extends Equatable {
  const HistorialEvent();

  @override
  List<Object> get props => [];
}

class GetHistorialEvent extends HistorialEvent {}
