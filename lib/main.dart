import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:paganini_wallet/core/theme/theme.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/core/router/app_router.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/register_form_cubit.dart';
import 'package:paganini_wallet/features/history/presentation/bloc/historial/historial_bloc.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/bloc/contactos/contactos_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/bloc/pagos/pagos_bloc.dart';
import 'injection_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _setupLocalNotifications() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const channel = AndroidNotificationChannel(
    'default_channel_id',
    'Notificaciones generales',
    description: 'Canal por defecto para alertas',
    importance: Importance.high,
  );

  final androidPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(channel);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _initFirebaseAndMessaging() async {
  await Firebase.initializeApp();

  await initializeDateFormatting('es');
  Intl.defaultLocale = 'es';

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
}

void _wireUpForegroundNotifications() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel_id',
            'Notificaciones generales',
            channelDescription: 'Canal por defecto para alertas',
            priority: Priority.high,
            importance: Importance.high,
          ),
        ),
        payload: message.data.isNotEmpty ? message.data.toString() : null,
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final data = message.data;
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  await Environment.initializeEnv();

  await _setupLocalNotifications();
  await _initFirebaseAndMessaging();

  await SentryFlutter.init(
    (options) {
      options.dsn = dsnSentry;
    },
    appRunner: () => SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    ).then((_) {
      _wireUpForegroundNotifications();
      runApp(const MyApp());
    }),
  );
  authBloc.add(CheckAuthStatusEvent());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final data = message.data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent())),
        BlocProvider(create: (_) => di.sl<LoginFormCubit>()),
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<RegisterFormCubit>()),
        BlocProvider(create: (_) => di.sl<ContactosBloc>()),
        BlocProvider(create: (_) => di.sl<MethodsBloc>()),
        BlocProvider(create: (_) => di.sl<PagosBloc>()),
        BlocProvider(create: (_) => di.sl<HistorialBloc>()),
      ],
      child: MaterialApp.router(
        routeInformationParser: appRouter.routeInformationParser,
        routerDelegate: appRouter.routerDelegate,
        routeInformationProvider: appRouter.routeInformationProvider,
        debugShowCheckedModeBanner: false,
        title: 'Paganini',
        theme: AppTheme().getTheme(context),
      ),
    );
  }
}
