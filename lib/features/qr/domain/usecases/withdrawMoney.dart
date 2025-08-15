import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/payment_repository.dart';

class WithdrawMoney implements UseCase<String, WithdrawParams> {
  final PaymentRepository repository;

  WithdrawMoney(this.repository);

  @override
  Future<Either<Failure, String>> call(WithdrawParams params) async {
    return await repository.withdrawMoney(params.methodId, params.amount);
  }
}

class WithdrawParams extends Equatable {
  final int methodId;
  final double amount;

  const WithdrawParams({required this.methodId, required this.amount});

  @override
  List<Object?> get props => [methodId, amount];
}
