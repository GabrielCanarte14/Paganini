import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/payments_methods/domain/repositories/repositories.dart';

class GetMethods implements UseCase<List<dynamic>, Params> {
  final PaymentMethodsRepository repository;

  GetMethods(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(Params params) async {
    return await repository.getPaymentMethods(params.email);
  }
}

class Params extends Equatable {
  final String email;

  const Params({required this.email});

  @override
  List<Object?> get props => [email];
}
