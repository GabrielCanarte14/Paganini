import 'package:dio/dio.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/qr/data/model/models.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class QrDataSource {
  Future<List<ContactModel>> getContacts();
  Future<ContactModel> registerContact(String correo);
  Future<String> deleteContact(String email);
}

class QrDataSourceImpl implements QrDataSource {
  final KeyValueStorageServiceImpl keyValueStorageService;
  final Dio _client;
  QrDataSourceImpl(this.keyValueStorageService, this._client);

  @override
  Future<List<ContactModel>> getContacts() async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.get(
        '$contactsUrl$email/contacts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        final data = result.data;
        final List<ContactModel> contactos = [];
        if (data is List) {
          for (final item in data) {
            contactos.add(ContactModel.fromJson(item));
          }
        }
        return contactos;
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ContactModel> registerContact(String correo) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        '$contactsUrl$email/contacts',
        data: {'correoContact': correo},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 201) {
        return ContactModel.fromJson(result.data);
      }
      throw ServerException(
        message: 'HTTP ${result.statusCode}: ${result.statusMessage}',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deleteContact(String correo) async {
    final email = await keyValueStorageService.getValue<String>('email');
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.delete(
        '$contactsUrl$email/contacts/$correo',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return result.data['message'];
      }
      throw ServerException(
          message: 'HTTP ${result.statusCode}: ${result.statusMessage}');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
