import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'detail_row.dart';

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({
    super.key,
    required this.date,
    required this.amount,
  });

  final DateTime date;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final fechaString = Formatters.dateYmd(date);
    final amountString = Formatters.currency(amount);

    final labelStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black38);

    return Column(
      children: [
        DetailRow(
          label: 'Fecha',
          value: fechaString,
          labelStyle: labelStyle,
          valueStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        DetailRow(
          label: 'Monto total',
          value: amountString,
          labelStyle: labelStyle,
          valueStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
