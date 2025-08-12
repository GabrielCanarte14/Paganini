import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/qr_repository.dart';

class Deletecontact implements UseCase<String, DeleteParams> {
  final QrRepository repository;

  Deletecontact(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteParams params) async {
    return await repository.deleteContact(params.correo);
  }
}

class DeleteParams extends Equatable {
  final String correo;

  const DeleteParams({
    required this.correo,
  });

  @override
  List<Object?> get props => [correo];
}
