import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/theme/theme.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/bloc.dart';
import 'core/router/app_router.dart';
import 'injection_container.dart' as di;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:paganini_wallet/core/constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Environment.initializeEnv();
  await SentryFlutter.init(
    (options) {
      options.dsn = dsnSentry;
    },
    appRunner: () =>
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
            .then((value) => runApp(const MyApp())),
  );
  authBloc.add(CheckAuthStatusEvent());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<AuthBloc>()),
          BlocProvider(create: (context) => di.sl<LoginFormCubit>()),
        ],
        child: MaterialApp.router(
            routeInformationParser: appRouter.routeInformationParser,
            routerDelegate: appRouter.routerDelegate,
            routeInformationProvider: appRouter.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            title: 'Paganini',
            theme: AppTheme().getTheme(context)));
  }
}
