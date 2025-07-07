import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:paganini_wallet/core/router/app_router_notifier.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/screens/screens.dart';
//import 'package:paganini_wallet/features/home/presentation/screens/screens.dart';
import 'package:paganini_wallet/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:paganini_wallet/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authBloc = sl<AuthBloc>();
final authListenable = AuthBlocListenable(authBloc);

final appRouter = GoRouter(
  navigatorKey: Get.key,
  initialLocation: '/splash',
  refreshListenable: authListenable,
  routes: [
    ///* CheckAuth Screen
    GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen()),

    ///* Auth Routes
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    ///* Home Routes
    GoRoute(
      path: '/home',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        return const OnBoarding();
      },
    ),
  ],
  redirect: (context, state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool seen = prefs.getBool('seen') ?? false;
    final isGoingTo = state.fullPath;

    if (authBloc.state is UserError && isGoingTo == '/splash') {
      return '/login';
    }

    if (authBloc.state is Checking) {
      return null;
    }

    if (authBloc.state is Authenticated) {
      if (isGoingTo == '/login' || isGoingTo == '/splash') {
        return '/home';
      }
      return null;
    }

    if (authBloc.state is Unauthenticated) {
      if (!seen) {
        return '/onboarding';
      }

      if (isGoingTo != '/login') {
        return '/login';
      }
    }

    return null;
  },
);
