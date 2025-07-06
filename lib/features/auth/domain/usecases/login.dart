import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/auth/domain/entities/entities.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/repositories.dart';

class Login implements UseCase<User, Params> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>?> call(Params params) async {
    return await repository.login(params.username, params.password);
  }
}

class Params extends Equatable {
  final String username;
  final String password;

  const Params({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
