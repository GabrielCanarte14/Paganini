import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<dynamic>>> getHistory();
}
