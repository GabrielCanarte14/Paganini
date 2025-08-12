import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/qr/data/model/contact_model.dart';
import 'package:paganini_wallet/features/qr/domain/repositories/repositories.dart';

class GetContacts implements UseCase<List<ContactModel>, NoParams> {
  final QrRepository repository;

  GetContacts(this.repository);

  @override
  Future<Either<Failure, List<ContactModel>>> call(NoParams params) async {
    return await repository.getContacts();
  }
}
