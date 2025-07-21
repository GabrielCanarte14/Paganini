import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/screens/registro_tarjeta_screen.dart';

class AddMethodModal extends StatelessWidget {
  const AddMethodModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Añadir método de pago',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            _OptionTile(
              icon: Icons.account_balance,
              text: 'Cuenta bancaria',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _OptionTile(
              icon: Icons.credit_card,
              text: 'Tarjeta de crédito o débito',
              onTap: () {
                context.pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RegistroTarjetaScreen(),
                  ),
                );
              },
            ),
            _OptionTile(
              icon: Icons.currency_exchange,
              text: 'Exchange',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
