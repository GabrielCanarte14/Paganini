import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/qr/data/datasources/payment_data_source.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/repositories.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource paymentDataSource;
  final KeyValueStorageServiceImpl keyValueStorageService;

  PaymentRepositoryImpl(
      {required this.paymentDataSource, required this.keyValueStorageService});

  @override
  Future<Either<Failure, String>> enviarDinero(
      String correo, double amount) async {
    try {
      final contactos = await paymentDataSource.paymentEmail(correo, amount);
      return Right(contactos);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
