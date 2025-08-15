import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/payment_repository.dart';

class QramountPayment implements UseCase<String, QrAmountPaymentParams> {
  final PaymentRepository repository;

  QramountPayment(this.repository);

  @override
  Future<Either<Failure, String>> call(QrAmountPaymentParams params) async {
    return await repository.enviarQrAmount(params.monto, params.payload);
  }
}

class QrAmountPaymentParams extends Equatable {
  final double monto;
  final String payload;

  const QrAmountPaymentParams({required this.monto, required this.payload});

  @override
  List<Object?> get props => [payload, monto];
}
