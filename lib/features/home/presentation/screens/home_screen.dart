import 'package:flutter/material.dart';
import 'package:paganini_wallet/features/home/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              WelcomeMessageWidget(),
              SizedBox(height: 30),
              BalanceCardWidget(),
              SizedBox(height: 30),
              PaymentMethodsWidget(),
              SizedBox(height: 30),
              RecentTransactionsWidget()
            ],
          ),
        ),
      ),
    );
  }
}
