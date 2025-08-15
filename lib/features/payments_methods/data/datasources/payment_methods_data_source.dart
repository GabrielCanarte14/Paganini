import 'package:dio/dio.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/models.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class PaymentMethodsDataSource {
  Future<List<dynamic>> getPaymentMethods(String correo);
  Future<String> registerPaymentMethod(
      String number,
      String titular,
      int? month,
      int? year,
      String? cvv,
      String tipo,
      String? red,
      String tipoMetodo,
      String? bank,
      String? identificacion);
  Future<String> deletePaymentMethod(int id);
}

class PaymentMethodsDataSourceImpl implements PaymentMethodsDataSource {
  final KeyValueStorageServiceImpl keyValueStorageService;
  final Dio _client;
  PaymentMethodsDataSourceImpl(this.keyValueStorageService, this._client);

  @override
  Future<List<dynamic>> getPaymentMethods(String correo) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    if (correo == '') {
      correo = email!;
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
        return metodos;
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> registerPaymentMethod(
      String number,
      String titular,
      int? month,
      int? year,
      String? cvv,
      String tipo,
      String? red,
      String tipoMetodo,
      String? bank,
      String? identificacion) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    var cuerpo = {};
    if (tipoMetodo == 'cuentabanco') {
      cuerpo = {
        "correo": email,
        "tipo": tipoMetodo,
        "bankAccount": {
          "nombreBanco": bank,
          "numeroCuenta": number,
          "tipoCuenta": tipo,
          "titular": titular,
          "identificacion": identificacion
        }
      };
    } else {
      cuerpo = {
        "correo": email,
        "tipo": tipoMetodo,
        "card": {
          "numeroTarjeta": number,
          "titular": titular,
          "mes": month,
          "year": year,
          "cvv": cvv,
          "tipo": tipo,
          "red": red
        }
      };
    }
    try {
      final result = await _client.post(
        registerPaymentMethodUrl,
        data: cuerpo,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 201) {
        return 'Su método de pago fue registrado correctamente';
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      print(e);
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deletePaymentMethod(int id) async {
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.delete(
        '$deletePaymentMethodUrl$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 204) {
        return 'Método de pago eliminado correctamente';
      }
      throw ServerException(
          message: 'HTTP ${result.statusCode}: ${result.statusMessage}');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
