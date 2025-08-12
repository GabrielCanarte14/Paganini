import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/failures.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, Unit>?> call(NoParams params) async {
    return await repository.logout();
  }
}
