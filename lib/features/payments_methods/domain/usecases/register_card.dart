import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/payments_methods/domain/repositories/repositories.dart';

class RegisterCard implements UseCase<String, CardParams> {
  final PaymentMethodsRepository repository;

  RegisterCard(this.repository);

  @override
  Future<Either<Failure, String>> call(CardParams params) async {
    return await repository.registerCard(params.number, params.titular,
        params.month, params.year, params.cvv, params.type, params.red);
  }
}

class CardParams extends Equatable {
  final String number;
  final String titular;
  final int month;
  final int year;
  final String cvv;
  final String type;
  final String red;

  const CardParams(
      {required this.number,
      required this.titular,
      required this.month,
      required this.year,
      required this.cvv,
      required this.type,
      required this.red});

  @override
  List<Object?> get props => [titular, number];
}
