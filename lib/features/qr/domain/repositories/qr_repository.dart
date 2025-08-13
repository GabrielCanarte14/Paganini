import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/qr/data/model/contact_model.dart';

abstract class QrRepository {
  Future<Either<Failure, List<ContactModel>>> getContacts();
  Future<Either<Failure, ContactModel>> registerContact(String email);
  Future<Either<Failure, String>> deleteContact(String email);
}
