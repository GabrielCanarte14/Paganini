import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/qr/data/datasources/qr_data_source.dart';
import 'package:paganini_wallet/features/qr/data/model/contact_model.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/repositories.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

class QrRepositoryImpl implements QrRepository {
  final QrDataSource qrDataSource;
  final KeyValueStorageServiceImpl keyValueStorageService;

  QrRepositoryImpl(
      {required this.qrDataSource, required this.keyValueStorageService});

  @override
  Future<Either<Failure, String>> deleteContact(String email) async {
    try {
      final mensaje = await qrDataSource.deleteContact(email);
      return Right(mensaje);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> enviarDinero(String monto, String correo) {
    // TODO: implement enviarDinero
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ContactModel>>> getContacts() async {
    try {
      final contactos = await qrDataSource.getContacts();
      return Right(contactos);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContactModel>> registerContact(String email) async {
    try {
      final contacto = await qrDataSource.registerContact(email);
      return Right(contacto);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
