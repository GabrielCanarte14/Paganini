import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/payments_methods/domain/repositories/repositories.dart';

class RegisterbankAccount implements UseCase<String, BankParams> {
  final PaymentMethodsRepository repository;

  RegisterbankAccount(this.repository);

  @override
  Future<Either<Failure, String>> call(BankParams params) async {
    return await repository.registerBankAccount(params.bank, params.number,
        params.type, params.titular, params.identificacion);
  }
}

class BankParams extends Equatable {
  final String number;
  final String titular;
  final String type;
  final String bank;
  final String identificacion;

  const BankParams(
      {required this.number,
      required this.titular,
      required this.type,
      required this.bank,
      required this.identificacion});

  @override
  List<Object?> get props => [titular, number];
}
