import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/core/usecases/usecases.dart';
import 'package:paganini_wallet/features/history/domain/repositories/history_repository.dart';

class Gethistory implements UseCase<List<dynamic>, NoParams> {
  final HistoryRepository repository;

  Gethistory(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(NoParams params) async {
    return await repository.getHistory();
  }
}
