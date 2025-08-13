import 'package:flutter/material.dart';

class QuickAmountChips extends StatelessWidget {
  const QuickAmountChips({
    super.key,
    required this.amounts,
    required this.onTapAmount,
  });

  final List<int> amounts;
  final ValueChanged<int> onTapAmount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: amounts.map((a) {
        return OutlinedButton(
          onPressed: () => onTapAmount(a),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black26),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child:
              Text('S$a', style: const TextStyle(fontWeight: FontWeight.w600)),
        );
      }).toList(),
    );
  }
}
