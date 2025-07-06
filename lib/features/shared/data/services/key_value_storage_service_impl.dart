import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'key_value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  final _storage = const FlutterSecureStorage();

  @override
  Future<T?> getValue<T>(String key) async {
    try {
      String? value = await _storage.read(key: key);
      if (T == String) {
        return value as T?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    await _storage.delete(key: key);
    return true;
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    if (T == String) {
      await _storage.write(key: key, value: value as String);
    } else {
      throw UnimplementedError('Set not implemented for type ${T.runtimeType}');
    }
  }
}
