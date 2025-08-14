import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/repositories.dart';

class ResetPasswordUseCase implements UseCase<void, ResetParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, String>?> call(ResetParams params) async {
    return await repository.resetPassword(
        params.codigo, params.email, params.password);
  }
}

class ResetParams extends Equatable {
  final String email;
  final String password;
  final String codigo;

  const ResetParams({
    required this.email,
    required this.codigo,
    required this.password,
  });

  @override
  List<Object?> get props => [email];
}
