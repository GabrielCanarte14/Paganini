import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/models.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class PaymentMethodsDataSource {
  Future<List<dynamic>> getPaymentMethods(String correo);
}

class PaymentMethodsDataSourceImpl implements PaymentMethodsDataSource {
  final KeyValueStorageServiceImpl keyValueStorageService;
  final Dio _client;
  PaymentMethodsDataSourceImpl(this.keyValueStorageService, this._client);

  @override
  Future<List<dynamic>> getPaymentMethods(String correo) async {
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.get(
        getPaymentMethodsUrl,
        queryParameters: {"correo": correo},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          },
        ),
      );
      print(result);
      if (result.statusCode == 200) {
        final data = result.data as Map<String, dynamic>;
        final cuentas = (data['cuentabanco'] as List?) ?? const [];
        final tarjetas = (data['tarjeta'] as List?) ?? const [];
        final List<dynamic> metodos = [];
        for (final item in cuentas) {
          metodos.add(BankAccountModel.fromJson(item as Map<String, dynamic>));
        }
        for (final item in tarjetas) {
          metodos.add(CardModel.fromJson(item as Map<String, dynamic>));
        }
        print(metodos);
        return metodos;
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }
}
