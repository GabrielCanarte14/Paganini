import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/payment_repository.dart';

class TopUpMoney implements UseCase<String, TopUpParams> {
  final PaymentRepository repository;

  TopUpMoney(this.repository);

  @override
  Future<Either<Failure, String>> call(TopUpParams params) async {
    return await repository.topUpMoney(params.methodId, params.amount);
  }
}

class TopUpParams extends Equatable {
  final int methodId;
  final double amount;

  const TopUpParams({required this.methodId, required this.amount});

  @override
  List<Object?> get props => [methodId, amount];
}
