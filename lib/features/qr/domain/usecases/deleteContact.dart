import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/qr_repository.dart';

class DeleteContact implements UseCase<String, DeleteContactParams> {
  final QrRepository repository;

  DeleteContact(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteContactParams params) async {
    return await repository.deleteContact(params.correo);
  }
}

class DeleteContactParams extends Equatable {
  final String correo;

  const DeleteContactParams({
    required this.correo,
  });

  @override
  List<Object?> get props => [correo];
}
