import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'package:paganini_wallet/features/history/data/model/models.dart';

import 'package:paganini_wallet/features/history/presentation/bloc/historial/historial_bloc.dart';
import 'package:paganini_wallet/features/history/presentation/screens/comprobante_screen.dart';
import 'package:paganini_wallet/features/history/presentation/widgets/widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistorialBloc>().add(GetHistorialEvent());
  }

  String _formatHeaderDate(DateTime fecha) {
    try {
      final fmt = DateFormat('dd/MM/yyyy', 'es_ES');
      final s = fmt.format(fecha);
      return s[0].toUpperCase() + s.substring(1);
    } catch (_) {
      return DateFormat('dd/MM/yyyy').format(fecha);
    }
  }

  Map<String, List<dynamic>> _groupByDay(List<dynamic> items) {
    final map = <String, List<dynamic>>{};
    for (final it in items) {
      final DateTime f = _extractFecha(it);
      final header = _formatHeaderDate(DateTime(f.year, f.month, f.day));
      (map[header] ??= []).add(it);
    }
    final entries = map.entries.toList()
      ..sort((a, b) {
        DateTime parseHeader(String h) {
          try {
            final fmt = DateFormat('EEEE d \'de\' MMMM, yyyy', 'es_ES');
            return fmt.parse(h);
          } catch (_) {
            return DateFormat('dd/MM/yyyy').parse(h);
          }
        }

        return parseHeader(b.key).compareTo(parseHeader(a.key));
      });
    return {for (final e in entries) e.key: e.value};
  }

  DateTime _extractFecha(dynamic model) {
    if (model is EnvioModel) return model.fecha;
    if (model is RecargaModel) return model.fecha;
    if (model is ReciboModel) return model.fecha;
    if (model is RetiroModel) return model.fecha;
    return DateTime.now();
  }

  Widget _buildTxItem(BuildContext context, dynamic tx, String headerDateText) {
    if (tx is EnvioModel) {
      final concepto =
          'Envio a ${_nombreYCorreo(tx.nombre, tx.apellido, tx.correo)}';
      final valor = -(tx.amount);
      return TransaccionItem(
        concepto: concepto,
        valor: valor,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => ComprobanteScreen(
                concepto: concepto,
                fecha: headerDateText,
                idTransaccion: '#XXXXXXXX',
                monto: tx.amount,
              ),
            ),
          );
        },
      );
    } else if (tx is ReciboModel) {
      final concepto =
          'Pago de ${_nombreYCorreo(tx.nombre, tx.apellido, tx.correo)}';
      final valor = tx.amount;
      return TransaccionItem(
        concepto: concepto,
        valor: valor,
        onTap: null,
      );
    } else if (tx is RecargaModel) {
      final concepto = 'Recarga ${tx.red}';
      final valor = tx.amount;
      return TransaccionItem(
        concepto: concepto,
        valor: valor,
        onTap: null,
      );
    } else if (tx is RetiroModel) {
      final concepto =
          'Retiro ${tx.banco} - Cuenta ${formatAccountType(tx.tipo)} - ${tx.titular}';
      final valor = tx.amount;
      return TransaccionItem(
        concepto: concepto,
        valor: valor,
        onTap: null,
      );
    }
    return const SizedBox.shrink();
  }

  String _nombreYCorreo(String nombre, String apellido, String correo) {
    final base = '$nombre $apellido'.trim();
    if (base.isEmpty) return correo;
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
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
      body: BlocBuilder<HistorialBloc, HistorialState>(
        builder: (context, state) {
          if (state is Consultando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HistorialError) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message,
                      style: textStyle.bodyMedium?.copyWith(color: Colors.red)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context
                          .read<HistorialBloc>()
                          .add(GetHistorialEvent()),
                      child: const Text('Reintentar'),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is Completo) {
            final List<dynamic> items = state.historial;
            if (items.isEmpty) {
              return const Center(child: Text('No hay movimientos'));
            }
            final grouped = _groupByDay(items);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ListView(
                children: grouped.entries.map((entry) {
                  final headerText = entry.key;
                  final list = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headerText,
                        style: textStyle.titleSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...list
                          .map((tx) => _buildTxItem(context, tx, headerText)),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
