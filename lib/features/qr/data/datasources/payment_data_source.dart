import 'package:dio/dio.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/qr/data/model/models.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class PaymentDataSource {
  Future<String> paymentEmail(String correo, double amount);
  Future<String> paymentQr(String correo, double amount);
  Future<String> paymentQrAmount(String payload, double amount);
  Future<QrPayloadModel> generateAmmountQr(double amount);
  Future<String> withdrawMoney(double amount, int methodId);
  Future<String> topUpMoney(double amount, int methodId);
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final KeyValueStorageServiceImpl keyValueStorageService;
  final Dio _client;
  PaymentDataSourceImpl(this.keyValueStorageService, this._client);

  @override
  Future<String> paymentEmail(String correo, double amount) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        paymentUrl,
        data: {"senderEmail": email, "receiverEmail": correo, "monto": amount},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return 'Pago realizado con exito';
      }
      if (result.statusCode == 400) {
        return result.data['message'];
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<QrPayloadModel> generateAmmountQr(double amount) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        generateQrUrl,
        data: {"correoSolicitante": email, "monto": amount},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return QrPayloadModel.fromJson(result.data);
      }
      if (result.statusCode == 400) {
        return result.data['error'];
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> topUpMoney(double amount, int methodId) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        topUpUrl,
        data: {
          "email": email,
          "metodoPagoId": methodId,
          "monto": amount,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return result.data['mensaje'];
      }
      if (result.statusCode == 400) {
        return result.data['message'];
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> withdrawMoney(double amount, int methodId) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        withdrawUrl,
        data: {
          "email": email,
          "metodoPagoId": methodId,
          "monto": amount,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return result.data['mensaje'];
      }
      if (result.statusCode == 400) {
        return result.data['message'];
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> paymentQrAmount(String payload, double amount) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        paymentQrAmountUrl,
        data: {"senderEmail": email, "qrPayload": payload, "monto": amount},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return 'Pago realizado con exito';
      }
      if (result.statusCode == 400) {
        return result.data['message'];
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> paymentQr(String correo, double amount) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        paymentQrUrl,
        data: {
          "senderEmail": email,
          "qrPayload": "{\"t\":\"PAYREQ\",\"c\":\"$correo\",\"m\":\"$amount\"}",
          "monto": amount,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return 'Pago realizado con exito';
      }
      if (result.statusCode == 400) {
        return result.data['message'];
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
