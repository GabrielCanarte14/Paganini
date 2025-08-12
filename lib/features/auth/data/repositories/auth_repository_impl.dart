import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:paganini_wallet/features/auth/data/model/user_model.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final KeyValueStorageServiceImpl keyValueStorageService;

  AuthRepositoryImpl(
      {required this.authRemoteDataSource,
      required this.keyValueStorageService});

  @override
  Future<Either<Failure, void>?> login(String username, String password) async {
    try {
      await authRemoteDataSource.login(username, password);
      return Right(null);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>?> registerUser(String name, String lastname,
      String email, String phone, String password) async {
    try {
      final mensaje = await authRemoteDataSource.registerUser(
          name, lastname, email, phone, password);
      return Right(mensaje);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>?> logout() async {
    try {
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, String>?> forgotPassword(String email) async {
    try {
      final codigo = await authRemoteDataSource.forgotPassword(email);
      return Right(codigo);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      final usuario = await authRemoteDataSource.getUserData();
      return Right(usuario);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message));
    }
  }
}
