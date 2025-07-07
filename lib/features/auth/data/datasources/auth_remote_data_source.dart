import 'package:paganini_wallet/features/auth/data/model/user_model.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final KeyValueStorageServiceImpl keyValueStorageService;
  AuthRemoteDataSourceImpl(this.keyValueStorageService);

  @override
  Future<UserModel> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
