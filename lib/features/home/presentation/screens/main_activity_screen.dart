import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:paganini_wallet/features/history/presentation/screens/history_screen.dart';
import 'package:paganini_wallet/features/home/presentation/screens/home_screen.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/screens/payments_methods_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/qr_screen.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';
import 'package:paganini_wallet/features/user/presentation/screens/user_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:paganini_wallet/features/shared/data/services/key_value_storage_service_impl.dart';

final getIt = GetIt.instance;

class MainActivityScreen extends StatefulWidget {
  const MainActivityScreen({super.key});

  @override
  State<MainActivityScreen> createState() => _MainActivityScreenState();
}

class _MainActivityScreenState extends State<MainActivityScreen> {
  late PersistentTabController _controller;
  String? _email;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final storage = getIt<KeyValueStorageServiceImpl>();
    final email = await storage.getValue<String>('email');
    setState(() => _email = email);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(controller: _controller),
      const HistoryScreen(),
      const QrScreen(),
      _email == null
          ? const Center(child: CircularProgressIndicator())
          : PaymentsMethodsScreen(email: _email!),
      const UserScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_email == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return CustomPersistentNavBar(
      context: context,
      controller: _controller,
      screens: _buildScreens(),
    );
  }
}
