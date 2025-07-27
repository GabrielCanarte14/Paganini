import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/repositories.dart';

class RegisterUser implements UseCase<String, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, String>?> call(RegisterParams params) async {
    return await repository.registerUser(params.name, params.lastname,
        params.email, params.phone, params.password);
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String lastname;
  final String email;
  final String phone;
  final String password;

  const RegisterParams(
      {required this.name,
      required this.lastname,
      required this.email,
      required this.phone,
      required this.password});

  @override
  List<Object?> get props => [name, email];
}
