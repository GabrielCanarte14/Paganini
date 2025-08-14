import 'package:dio/dio.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/history/data/model/models.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class HistoryDataSource {
  Future<List<dynamic>> getHistory();
}

class HistoryDataSourceImpl implements HistoryDataSource {
  final KeyValueStorageServiceImpl keyValueStorageService;
  final Dio _client;
  HistoryDataSourceImpl(this.keyValueStorageService, this._client);

  @override
  Future<List<dynamic>> getHistory() async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.get(
        getHistoryUrl,
        queryParameters: {"correo": email},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        final data = result.data as Map<String, dynamic>;
        final envios = (data['envios'] as List?) ?? const [];
        final recibos = (data['recibos'] as List?) ?? const [];
        final retiros = (data['retiros'] as List?) ?? const [];
        final recargas = (data['recargas'] as List?) ?? const [];
        final List<dynamic> historial = [];
        for (final item in envios) {
          historial.add(EnvioModel.fromJson(item as Map<String, dynamic>));
        }
        for (final item in recibos) {
          historial.add(ReciboModel.fromJson(item as Map<String, dynamic>));
        }
        for (final item in retiros) {
          historial.add(RetiroModel.fromJson(item as Map<String, dynamic>));
        }
        for (final item in recargas) {
          historial.add(RecargaModel.fromJson(item as Map<String, dynamic>));
        }
        return historial;
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      print(e);
      throw ServerException(message: e.toString());
    }
  }
}
