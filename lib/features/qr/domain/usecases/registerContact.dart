import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/data/model/contact_model.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/qr_repository.dart';

class RegisterContact implements UseCase<ContactModel, ContactParams> {
  final QrRepository repository;

  RegisterContact(this.repository);

  @override
  Future<Either<Failure, ContactModel>> call(ContactParams params) async {
    return await repository.registerContact(params.correo);
  }
}

class ContactParams extends Equatable {
  final String correo;

  const ContactParams({
    required this.correo,
  });

  @override
  List<Object?> get props => [correo];
}
