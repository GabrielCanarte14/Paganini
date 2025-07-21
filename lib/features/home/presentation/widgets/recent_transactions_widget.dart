import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';

class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        'name': 'Gabriel Cañarte',
        'date': '13 Julio, 2025',
        'amount': '+ \$40.35'
      },
      {
        'name': 'Gabriel Cañarte',
        'date': '13 Julio, 2025',
        'amount': '+ \$25.00'
      },
      {
        'name': 'Gabriel Cañarte',
        'date': '13 Julio, 2025',
        'amount': '- \$15.75'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Transacciones recientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('Ver todas', style: TextStyle(color: primaryColor)),
          ],
        ),
        const SizedBox(height: 12),
        ...transactions.map((tx) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(tx['name'] as String),
            subtitle: Text(tx['date'] as String),
            trailing: Text(
              tx['amount'] as String,
              style: TextStyle(
                color: (tx['amount'] as String).contains('-')
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
