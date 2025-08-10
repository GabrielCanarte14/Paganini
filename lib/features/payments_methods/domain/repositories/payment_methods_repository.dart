import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';

abstract class PaymentMethodsRepository {
  Future<Either<Failure, List<dynamic>>> getPaymentMethods(String email);
}
