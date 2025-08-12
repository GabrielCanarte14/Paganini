import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/auth/data/model/models.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/auth_repository.dart';

class GetUserData implements UseCase<UserModel, NoParams> {
  final AuthRepository repository;

  GetUserData(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(NoParams params) async {
    return await repository.getUserData();
  }
}
