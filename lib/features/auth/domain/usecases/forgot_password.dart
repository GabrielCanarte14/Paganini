import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/repositories.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, String>?> call(ForgotParams params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotParams extends Equatable {
  final String email;

  const ForgotParams({required this.email});

  @override
  List<Object?> get props => [email];
}
