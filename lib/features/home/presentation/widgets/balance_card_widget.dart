import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';

class BalanceCardWidget extends StatelessWidget {
  const BalanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.arrow_upward_rounded, 'label': 'Enviar'},
      {'icon': Icons.arrow_downward_rounded, 'label': 'Recibir'},
      {'icon': Icons.add, 'label': 'Recargar'},
      {'icon': Icons.miscellaneous_services, 'label': 'Retirar'},
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
          const Text(
            '\$1.250,00',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((action) {
              return Column(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child:
                        Icon(action['icon'] as IconData, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(action['label'] as String),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
