import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/payments_methods/domain/repositories/repositories.dart';

class DeletePaymentMethod implements UseCase<String, DeleteParams> {
  final PaymentMethodsRepository repository;

  DeletePaymentMethod(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteParams params) async {
    return await repository.deletePaymentMethod(params.id);
  }
}

class DeleteParams extends Equatable {
  final int id;

  const DeleteParams({required this.id});

  @override
  List<Object?> get props => [id];
}
