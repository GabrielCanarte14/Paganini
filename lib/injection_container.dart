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
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';
import 'package:path_provider/path_provider.dart';

import 'features/auth/domain/usecases/usecases.dart';

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
  //* Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
      keyValueStorageService: sl()));

  //* Usecase
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => KeyValueStorageServiceImpl());

  //! Auth
  sl.registerLazySingleton(() => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      registerUserUseCase: sl(),
      forgotPasswordUseCase: sl(),
      keyValueStorageService: sl<KeyValueStorageServiceImpl>()));

  sl.registerLazySingleton(() => LoginFormCubit());
  sl.registerLazySingleton(() => RegisterFormCubit());
}
