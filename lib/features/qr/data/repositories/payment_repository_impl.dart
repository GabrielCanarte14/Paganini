import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/qr/data/datasources/payment_data_source.dart';
import 'package:paganini_wallet/features/qr/data/model/qr_payload_model.dart';
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

  @override
  Future<Either<Failure, QrPayloadModel>> generateAmmountQr(
      double amount) async {
    try {
      final qr = await paymentDataSource.generateAmmountQr(amount);
      return Right(qr);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> topUpMoney(
      int methodID, double amount) async {
    try {
      final result = await paymentDataSource.topUpMoney(amount, methodID);
      return Right(result);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> withdrawMoney(
      int methodID, double amount) async {
    try {
      final result = await paymentDataSource.withdrawMoney(amount, methodID);
      return Right(result);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> enviarQr(double amount, String email) async {
    try {
      final resultado = await paymentDataSource.paymentQr(email, amount);
      return Right(resultado);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> enviarQrAmount(
      double amount, String payload) async {
    try {
      final resultado =
          await paymentDataSource.paymentQrAmount(payload, amount);
      return Right(resultado);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
