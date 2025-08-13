import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> enviarDinero(String correo, double amount);
}
