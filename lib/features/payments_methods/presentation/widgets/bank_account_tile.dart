import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/models.dart';

class BankItem extends StatelessWidget {
  final BankAccountModel model;
  final VoidCallback? onLongPress;
  const BankItem({super.key, required this.model, this.onLongPress});

  String _maskAccount(String num) {
    if (num.length <= 6) return num;
    final last4 = num.substring(num.length - 4);
    return '**** **** $last4';
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      model.tipo == AccountType.ahorro ? 'Ahorro' : 'Corriente',
      _maskAccount(model.number),
    ].join(' • ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onLongPress: onLongPress, // Solo reacciona al mantener presionado
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300, // Borde gris
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Sombra suave
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.account_balance)),
            title: Text(model.bank),
            subtitle: Text(subtitle),
          ),
        ),
      ),
    );
  }
}
