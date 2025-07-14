import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.send, 'label': 'Enviar'},
      {'icon': Icons.download, 'label': 'Recibir'},
      {'icon': Icons.add_circle_outline, 'label': 'Recargar'},
      {'icon': Icons.miscellaneous_services, 'label': 'Servicios'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) {
        return Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(action['icon'] as IconData, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(action['label'] as String),
          ],
        );
      }).toList(),
    );
  }
}
