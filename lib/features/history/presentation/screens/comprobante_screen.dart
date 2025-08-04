import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';

class ComprobanteScreen extends StatelessWidget {
  final String concepto;
  final String fecha;
  final String idTransaccion;
  final double monto;

  const ComprobanteScreen({
    super.key,
    required this.concepto,
    required this.fecha,
    required this.idTransaccion,
    required this.monto,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        centerTitle: false,
        title: Text(
          'Comprobante',
          style: textStyle.titleMedium!.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.verified,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              'Pago realizado de forma segura:',
              textAlign: TextAlign.center,
              style: textStyle.bodyMedium,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    concepto,
                    style: textStyle.bodyMedium,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Detalle de la transacción',
                style:
                    textStyle.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            _detalleItem('Fecha', fecha),
            _detalleItem('ID de la transacción', idTransaccion),
            _detalleItem('Monto total', '\$${monto.toStringAsFixed(2)}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'Compartir',
                style: textStyle.titleSmall!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalleItem(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          Text(valor,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
