import 'package:dio/dio.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String username, String password);
  Future<String> registerUser(String name, String lastname, String email,
      String phone, String password);
  Future<String> forgotPassword(String email);
  Future<String> resetPassword(String codigo, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final KeyValueStorageServiceImpl keyValueStorageService;
  final Dio _client;
  AuthRemoteDataSourceImpl(this.keyValueStorageService, this._client);

  @override
  Future<void> login(String username, String password) async {
    try {
      final result = await _client.post(
        loginUrl,
        data: {"correo": username, "password": password},
        options: Options(contentType: 'application/json'),
      );
      if (result.statusCode == 401) {
        throw ServerException(message: result.data['error']);
      }
      if (result.statusCode == 200) {
        await keyValueStorageService.setKeyValue(
            'token', result.data['accessToken'].toString());
        await keyValueStorageService.setKeyValue(
            'refreshToken', result.data['refreshToken'].toString());
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> registerUser(String name, String lastname, String email,
      String phone, String password) async {
    try {
      final result = await _client.post(registerUserUrl, data: {
        'nombre': name,
        'apellido': lastname,
        'correo': email,
        'telefono': phone,
        'password': password
      });
      print('Hola ${result.statusCode}');
      if (result.statusCode != 201) {
        throw ServerException(message: result.data['message']);
      }

      return result.data['message'];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    try {
      final result =
          await _client.post(forgotPasswordUrl, data: {'correo': email});
      if (result.statusCode != 200) {
        throw ServerException(message: 'No se ha podido enviar el codigo');
      }
      return result.data['message'];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> resetPassword(
      String codigo, String email, String password) async {
    try {
      final result = await _client.post(resetPasswordUrl,
          data: {'correo': email, 'codigo': codigo, 'newPassword': password});
      print(result);
      if (result.data['status'] == 400) {
        return result.data['status'];
      }
      return result.data['message'];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
