import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/auth/data/model/user_model.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String username, String password);
  Future<String> registerUser(String name, String lastname, String email,
      String phone, String password);
  Future<String> forgotPassword(String email);
  Future<String> resetPassword(String codigo, String email, String password);
  Future<UserModel> getUserData();
  Future<void> registerDevice();
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
        await keyValueStorageService.setKeyValue('email', username);
        await registerDevice();
      }
    } catch (e) {
      throw ServerException(message: 'Usuario o contraseña incorrecto');
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
      if (result.statusCode != 201) {
        throw ServerException(message: result.data['message']);
      }

      return result.data['message'];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> registerDevice() async {
    final email = await keyValueStorageService.getValue<String>('email');
    final token = await FirebaseMessaging.instance.getToken();
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final userToken =
        rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.post(
        getNotificacionesUrl,
        data: {
          'correo': email,
          'token': token,
          'plataforma': 'ANDROID',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
            'Accept': 'application/json'
          },
        ),
      );
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
      print('cambiando nueva contrasenia');
      final result = await _client.post(resetPasswordUrl,
          data: {'correo': email, 'codigo': codigo, 'newPassword': password});
      if (result.data['status'] == 400) {
        return result.data['status'];
      }
      return result.data['message'];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserData() async {
    final rawToken = await keyValueStorageService.getValue<String>('token');
    final email = await keyValueStorageService.getValue<String>('email');
    final token = rawToken?.trim().replaceAll('\r', '').replaceAll('\n', '');
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      throw TimeoutException();
    }
    try {
      final result = await _client.get(
        getUserDataUrl,
        queryParameters: {"correo": email},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          },
        ),
      );
      if (result.statusCode == 200) {
        return UserModel.fromJson(result.data);
      }
      throw ServerException(
          message: 'HTTP ${result.statusCode}: ${result.statusMessage}');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
