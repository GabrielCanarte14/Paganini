import 'package:flutter/material.dart';
import 'package:paganini_wallet/features/home/presentation/screens/home_screen.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/screens/payments_methods_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/qr_screen.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';
import 'package:paganini_wallet/features/user/presentation/screens/user_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainActivityScreen extends StatefulWidget {
  const MainActivityScreen({super.key});

  @override
  State<MainActivityScreen> createState() => _HMainActivityScreenState();
}

class _HMainActivityScreenState extends State<MainActivityScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return const [
      HomeScreen(),
      PaymentsMethodsScreen(),
      QrScreen(),
      PaymentsMethodsScreen(),
      UserScreen(),
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
