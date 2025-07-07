import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>?> login(String email, String password);
  Future<Either<Failure, Unit>?> logout();
}
