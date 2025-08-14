import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/qr/data/model/models.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> enviarDinero(String correo, double amount);
  Future<Either<Failure, QrPayloadModel>> generateAmmountQr(double amount);
}
