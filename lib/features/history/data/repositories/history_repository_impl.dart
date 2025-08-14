import 'package:dartz/dartz.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/history/data/datasources/history_data_source.dart';
import 'package:paganini_wallet/features/history/domain/repositories/repositories.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDataSource historyDataSource;
  final KeyValueStorageServiceImpl keyValueStorageService;

  HistoryRepositoryImpl(
      {required this.historyDataSource, required this.keyValueStorageService});

  @override
  Future<Either<Failure, List<dynamic>>> getHistory() async {
    try {
      final metodos = await historyDataSource.getHistory();
      return Right(metodos);
    } on ServerException catch (e) {
      return Left(DioFailure(errorMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
