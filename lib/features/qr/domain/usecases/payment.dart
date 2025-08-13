import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/payment_repository.dart';

class Payment implements UseCase<String, PaymentParams> {
  final PaymentRepository repository;

  Payment(this.repository);

  @override
  Future<Either<Failure, String>> call(PaymentParams params) async {
    return await repository.enviarDinero(params.correo, params.amount);
  }
}

class PaymentParams extends Equatable {
  final String correo;
  final double amount;

  const PaymentParams({required this.correo, required this.amount});

  @override
  List<Object?> get props => [correo, amount];
}
