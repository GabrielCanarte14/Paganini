import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/data/model/models.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/repositories.dart';

class GenerateAmountQr implements UseCase<QrPayloadModel, AmountQrParams> {
  final PaymentRepository repository;

  GenerateAmountQr(this.repository);

  @override
  Future<Either<Failure, QrPayloadModel>> call(AmountQrParams params) async {
    return await repository.generateAmmountQr(params.amount);
  }
}

class AmountQrParams extends Equatable {
  final double amount;

  const AmountQrParams({
    required this.amount,
  });

  @override
  List<Object?> get props => [amount];
}
