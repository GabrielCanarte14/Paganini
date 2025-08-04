import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';

import '../widgets/transaction_widget.dart';
import 'comprobante_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    final Map<String, List<Map<String, dynamic>>> transacciones = {
      'Martes 17 de junio, 2025': [
        {'concepto': 'Consumo Visa na aki Jipijapa', 'valor': -40.35},
        {
          'concepto': 'Consumo Visa Pedidosya Restaurante Caba',
          'valor': -13.60
        },
        {'concepto': 'Impuesto isd Pedidosya', 'valor': -0.68},
      ],
      'Lunes 16 de junio, 2025': [
        {'concepto': 'Gabriel Cañarte', 'valor': 40.35},
        {'concepto': 'Gabriel Cañarte', 'valor': 40.35},
      ],
    };

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        centerTitle: false,
        title: Text(
          'Movimientos',
          style: textStyle.titleMedium!.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView(
          children: transacciones.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: textStyle.titleSmall!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ...entry.value.map((tx) {
                  return TransaccionItem(
                    concepto: tx['concepto'] as String,
                    valor: tx['valor'] as double,
                    onTap: (tx['valor'] as double) < 0
                        ? () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => ComprobanteScreen(
                                  concepto: (tx['concepto'] as String?) ?? '',
                                  fecha: entry.key,
                                  idTransaccion: '#XXXXXXXX',
                                  monto: (tx['valor'] as double).abs(),
                                ),
                              ),
                            );
                          }
                        : null,
                  );
                }),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
