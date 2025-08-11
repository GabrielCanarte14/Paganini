import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';

abstract class PaymentMethodsRepository {
  Future<Either<Failure, List<dynamic>>> getPaymentMethods(String email);
  Future<Either<Failure, String>> registerBankAccount(String bank,
      String number, String type, String titular, String identificacion);
  Future<Either<Failure, String>> registerCard(String number, String titular,
      int month, int year, String cvv, String tipo, String red);
  Future<Either<Failure, String>> deletePaymentMethod(int id);
}
