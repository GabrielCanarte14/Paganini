import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paganini_wallet/core/network/network_info.dart';
import 'package:paganini_wallet/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:paganini_wallet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:paganini_wallet/features/auth/domain/repositories/auth_repository.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/register_form_cubit.dart';
import 'package:paganini_wallet/features/payments_methods/data/datasources/payment_methods_data_source.dart';
import 'package:paganini_wallet/features/payments_methods/data/repositories/repositories.dart';
import 'package:paganini_wallet/features/payments_methods/domain/repositories/repositories.dart';
import 'package:paganini_wallet/features/payments_methods/domain/usecases/register_card.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';
import 'package:path_provider/path_provider.dart';

import 'features/auth/domain/usecases/usecases.dart';
import 'features/payments_methods/domain/usecases/usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  sl.registerLazySingleton(() => Dio());
  Hive.init((await getApplicationDocumentsDirectory()).path);

  sl.registerLazySingleton<Box<dynamic>>(() => Hive.box('UserModel'),
      instanceName: 'UserModel');

  await Hive.openBox('UserModel');

  //!Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //* Datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<PaymentMethodsDataSource>(
      () => PaymentMethodsDataSourceImpl(sl(), sl()));
  //* Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
      keyValueStorageService: sl()));
  sl.registerLazySingleton<PaymentMethodsRepository>(() =>
      PaymentMethodsRepositoryImpl(
          paymentMethodsDataSource: sl<PaymentMethodsDataSource>(),
          keyValueStorageService: sl()));

  //* Usecase
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => KeyValueStorageServiceImpl());
  sl.registerLazySingleton(() => GetMethods(sl()));
  sl.registerLazySingleton(() => RegisterCard(sl()));

  //! Auth
  sl.registerLazySingleton(() => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      registerUserUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
      keyValueStorageService: sl<KeyValueStorageServiceImpl>()));

  sl.registerLazySingleton(() => MethodsBloc(
      getMethodsUseCase: sl(),
      registerCardUseCase: sl(),
      keyValueStorageService: sl<KeyValueStorageServiceImpl>()));

  sl.registerLazySingleton(() => LoginFormCubit());
  sl.registerLazySingleton(() => RegisterFormCubit());
}
