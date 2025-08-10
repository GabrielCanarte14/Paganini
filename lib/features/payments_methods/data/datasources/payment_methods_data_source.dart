import 'package:dio/dio.dart';
import 'package:paganini_wallet/core/constants/api_constants.dart';
import 'package:paganini_wallet/core/error/error.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

abstract class PaymentMethodsDataSource {
  Future<void> login(String username, String password);
}

class PaymentMethodsDataSourceImpl implements PaymentMethodsDataSource {
  final PaymentMethodsDataSourceImpl keyValueStorageService;
  final Dio _client;
  PaymentMethodsDataSourceImpl(this.keyValueStorageService, this._client);
}
