import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'package:paganini_wallet/features/history/data/model/models.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/history/presentation/bloc/historial/historial_bloc.dart';

class RecentTransactionsWidget extends StatefulWidget {
  final PersistentTabController controller;
  const RecentTransactionsWidget({super.key, required this.controller});

  @override
  State<RecentTransactionsWidget> createState() =>
      _RecentTransactionsWidgetState();
}

class _RecentTransactionsWidgetState extends State<RecentTransactionsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<HistorialBloc>().add(GetHistorialEvent());
  }

  String _formatFecha(DateTime fecha) {
    try {
      final f = DateFormat('d MMMM, yyyy', 'es_ES');
      final s = f.format(fecha);
      return s[0].toUpperCase() + s.substring(1);
    } catch (_) {
      return DateFormat('dd/MM/yyyy').format(fecha);
    }
  }

  ({String avatar, String title, String subtitle, String? amount, bool isNeg})
      _mapItem(dynamic item) {
    if (item is EnvioModel) {
      final nombre = '${item.nombre} ${item.apellido}'.trim();
      return (
        avatar: (item.nombre.isNotEmpty ? item.nombre[0] : 'E').toUpperCase(),
        title: nombre.isEmpty ? item.correo : nombre,
        subtitle: _formatFecha(item.fecha),
        amount: '- \$${item.amount.toStringAsFixed(2)}',
        isNeg: true,
      );
    }
    if (item is ReciboModel) {
      final nombre = '${item.nombre} ${item.apellido}'.trim();
      return (
        avatar: '',
        title: nombre.isEmpty ? item.correo : nombre,
        subtitle: _formatFecha(item.fecha),
        amount: '+ \$${item.amount.toStringAsFixed(2)}',
        isNeg: false,
      );
    }
    if (item is RecargaModel) {
      return (
        avatar: '',
        title: 'Recarga ${item.red}',
        subtitle: _formatFecha(item.fecha),
        amount: '+ \$${item.amount.toStringAsFixed(2)}',
        isNeg: false,
      );
    }
    if (item is RetiroModel) {
      return (
        avatar: '',
        title:
            'Retiro ${item.banco} - Cuenta ${formatAccountType(item.tipo)} - ${item.titular}',
        subtitle: _formatFecha(item.fecha),
        amount: '-${item.amount.toString()}',
        isNeg: true,
      );
    }
    return (
      avatar: '',
      title: 'Transacción',
      subtitle: '',
      amount: null,
      isNeg: false
    );
  }

  List<dynamic> _ordenarYTomar3(List<dynamic> items) {
    items.sort((a, b) {
      DateTime fa, fb;
      if (a is EnvioModel) {
        fa = a.fecha;
      } else if (a is ReciboModel) {
        fa = a.fecha;
      } else if (a is RecargaModel) {
        fa = a.fecha;
      } else if (a is RetiroModel) {
        fa = a.fecha;
      } else {
        fa = DateTime.fromMillisecondsSinceEpoch(0);
      }
      if (b is EnvioModel) {
        fb = b.fecha;
      } else if (b is ReciboModel) {
        fb = b.fecha;
      } else if (b is RecargaModel) {
        fb = b.fecha;
      } else if (b is RetiroModel) {
        fb = b.fecha;
      } else {
        fb = DateTime.fromMillisecondsSinceEpoch(0);
      }
      return fb.compareTo(fa);
    });
    return items.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<HistorialBloc, HistorialState>(
      builder: (context, state) {
        Widget content;

        if (state is Checking) {
          content = const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HistorialError) {
          content = Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () =>
                      context.read<HistorialBloc>().add(GetHistorialEvent()),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        } else if (state is Complete) {
          final items = _ordenarYTomar3(List<dynamic>.from(state.historial));
          if (items.isEmpty) {
            content = const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No hay transacciones recientes'),
            );
          } else {
            content = Column(
              children: items.map((tx) {
                final m = _mapItem(tx);
                return ListTile(
                  title: Text(
                    m.title,
                    style:
                        textTheme.bodyMedium!.copyWith(color: Colors.black87),
                  ),
                  subtitle: Text(m.subtitle),
                  trailing: m.amount == null
                      ? null
                      : Text(
                          m.amount!,
                          style: TextStyle(
                              color: m.isNeg ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                );
              }).toList(),
            );
          }
        } else {
          content = const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transacciones recientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () => widget.controller.jumpToTab(1),
                  child:
                      Text('Ver todas', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        );
      },
    );
  }
}
