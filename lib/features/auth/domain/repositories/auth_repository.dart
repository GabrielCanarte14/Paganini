import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/auth/data/model/models.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>?> login(String email, String password);
  Future<Either<Failure, String>?> registerUser(String name, String lastname,
      String email, String phone, String password);
  Future<Either<Failure, Unit>?> logout();
  Future<Either<Failure, String>?> forgotPassword(String email);
  Future<Either<Failure, UserModel>> getUserData();
}
