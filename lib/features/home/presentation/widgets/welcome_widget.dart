import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/contactos_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class WelcomeAndBalanceWidget extends StatefulWidget {
  final PersistentTabController controller;
  const WelcomeAndBalanceWidget({required this.controller, super.key});

  @override
  State<WelcomeAndBalanceWidget> createState() =>
      _WelcomeAndBalanceWidgetState();
}

class _WelcomeAndBalanceWidgetState extends State<WelcomeAndBalanceWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = '';
        double balance = 0.0;

        if (state is UserInfo) {
          name = state.user.firstName;
          balance = state.user.saldo;
        } else if (state is UserError) {
          name = '';
          balance = 0.0;
        } else {
          name = '';
          balance = 0.0;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido${name.isNotEmpty ? ', $name' : ''}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _balanceCard(context, balance),
          ],
        );
      },
    );
  }

  Widget _balanceCard(BuildContext context, double amount) {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.arrow_upward_rounded,
        'label': 'Enviar',
        'accion': () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => ContactosScreen(),
              ),
            )
      },
      {
        'icon': Icons.arrow_downward_rounded,
        'label': 'Recibir',
        'accion': () => widget.controller.jumpToTab(2)
      },
      {
        'icon': Icons.add,
        'label': 'Recargar',
        'accion': () => widget.controller.jumpToTab(2)
      },
      {
        'icon': Icons.miscellaneous_services,
        'label': 'Servicios',
        'accion': () => widget.controller.jumpToTab(2)
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tu saldo',
              style: TextStyle(fontSize: 16, color: Colors.black45)),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((action) {
              return InkWell(
                onTap: action['accion'] as VoidCallback,
                borderRadius: BorderRadius.circular(50),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      child:
                          Icon(action['icon'] as IconData, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(action['label'] as String),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
