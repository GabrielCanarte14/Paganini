import 'package:equatable/equatable.dart';

class Card extends Equatable {
  final String number;
  final String titular;
  final String month;
  final String year;

  const Card(
      {required this.number,
      required this.titular,
      required this.month,
      required this.year});

  @override
  List<Object?> get props => [number, titular];
}
