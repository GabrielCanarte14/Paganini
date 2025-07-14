import 'package:flutter/material.dart';

class WelcomeMessageWidget extends StatelessWidget {
  const WelcomeMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 32, color: Colors.white),
        ),
        SizedBox(width: 12),
        Text(
          'Bienvenido, Gabriel',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
