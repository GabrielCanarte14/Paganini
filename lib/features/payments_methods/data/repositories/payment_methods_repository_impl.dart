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
}
