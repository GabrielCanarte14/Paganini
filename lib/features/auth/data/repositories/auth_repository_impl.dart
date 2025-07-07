import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:paganini_wallet/features/auth/domain/entities/user.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final KeyValueStorageServiceImpl keyValueStorageService;

  AuthRepositoryImpl(
      {required this.authRemoteDataSource,
      required this.keyValueStorageService});

  @override
  Future<Either<Failure, User>?> login(String username, String password) async {
    try {
      final remoteUser = await authRemoteDataSource.login(username, password);
      return Right(remoteUser);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: 'DioExeption'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>?> logout() async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      if (token != null && token != '') {
        await authRemoteDataSource.logout();
      }

      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.message));
    }
  }
}
