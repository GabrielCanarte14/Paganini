import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    );
  }
}
