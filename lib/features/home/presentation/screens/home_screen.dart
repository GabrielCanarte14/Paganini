import 'package:flutter/material.dart';
import 'package:paganini_wallet/features/home/presentation/widgets/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  final PersistentTabController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeMessageWidget(),
              SizedBox(height: 30),
              BalanceCardWidget(),
              SizedBox(height: 30),
              PaymentMethodsWidget(controller: controller),
              SizedBox(height: 30),
              RecentTransactionsWidget(controller: controller)
            ],
          ),
        ),
      ),
    );
  }
}
