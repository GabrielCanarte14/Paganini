import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/payment_repository.dart';

class QrPayment implements UseCase<String, QrPaymentParams> {
  final PaymentRepository repository;

  QrPayment(this.repository);

  @override
  Future<Either<Failure, String>> call(QrPaymentParams params) async {
    return await repository.enviarQr(params.monto, params.email);
  }
}

class QrPaymentParams extends Equatable {
  final double monto;
  final String email;

  const QrPaymentParams({required this.monto, required this.email});

  @override
  List<Object?> get props => [email, monto];
}
