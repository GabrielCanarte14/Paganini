import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/payments_methods/data/datasources/payment_methods_data_source.dart';
import 'package:paganini_wallet/features/payments_methods/domain/repositories/repositories.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  final PaymentMethodsDataSource paymentMethodsDataSource;
  final KeyValueStorageServiceImpl keyValueStorageService;

  PaymentMethodsRepositoryImpl(
      {required this.paymentMethodsDataSource,
      required this.keyValueStorageService});

  @override
  Future<Either<Failure, List<dynamic>>> getPaymentMethods(
      String username) async {
    try {
      final metodos =
          await paymentMethodsDataSource.getPaymentMethods(username);
      return Right(metodos);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> registerBankAccount(String bank,
      String number, String type, String titular, String identificacion) async {
    try {
      final mensaje = await paymentMethodsDataSource.registerPaymentMethod(
          number,
          titular,
          null,
          null,
          null,
          type,
          null,
          'cuentabanco',
          bank,
          identificacion);
      return Right(mensaje);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> registerCard(String number, String titular,
      int month, int year, String cvv, String tipo, String red) async {
    try {
      final mensaje = await paymentMethodsDataSource.registerPaymentMethod(
          number, titular, month, year, cvv, tipo, red, 'tarjeta', null, null);
      return Right(mensaje);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deletePaymentMethod(int id) async {
    try {
      final mensaje = await paymentMethodsDataSource.deletePaymentMethod(id);
      return Right(mensaje);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
