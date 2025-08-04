import 'package:flutter/material.dart';

class TransaccionItem extends StatelessWidget {
  final String concepto;
  final double valor;
  final VoidCallback? onTap;

  const TransaccionItem({
    super.key,
    required this.concepto,
    required this.valor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIngreso = valor >= 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                concepto,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              "${isIngreso ? '+' : '-'} \$${valor.abs().toStringAsFixed(2)}",
              style: TextStyle(
                color: isIngreso ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
