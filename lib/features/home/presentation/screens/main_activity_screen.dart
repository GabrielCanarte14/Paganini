import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:paganini_wallet/features/history/presentation/screens/history_screen.dart';
import 'package:paganini_wallet/features/home/presentation/screens/home_screen.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/screens/payments_methods_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/qr_screen.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';
import 'package:paganini_wallet/features/user/presentation/screens/user_screen.dart';
import 'package:paganini_wallet/injection_container.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

final getIt = GetIt.instance;

class MainActivityScreen extends StatefulWidget {
  const MainActivityScreen({super.key});

  @override
  State<MainActivityScreen> createState() => _MainActivityScreenState();
}

class _MainActivityScreenState extends State<MainActivityScreen> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(controller: _controller),
      const HistoryScreen(),
      const QrScreen(),
      PaymentsMethodsScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomPersistentNavBar(
      context: context,
      controller: _controller,
      screens: _buildScreens(),
    );
  }
}
