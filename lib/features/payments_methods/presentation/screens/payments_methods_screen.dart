import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/models.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/widgets/widgets.dart';

class PaymentsMethodsScreen extends StatefulWidget {
  final String email;
  const PaymentsMethodsScreen({super.key, required this.email});

  @override
  State<PaymentsMethodsScreen> createState() => _PaymentsMethodsScreenState();
}

class _PaymentsMethodsScreenState extends State<PaymentsMethodsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MethodsBloc>().add(GetMethodsEvent(email: widget.email));
  }

  Future<void> _refresh() async {
    context.read<MethodsBloc>().add(GetMethodsEvent(email: widget.email));
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text(
          'Métodos de pago',
          style: textTheme.titleMedium!.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (context) => const AddMethodModal(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MethodsBloc, MethodsState>(
        builder: (context, state) {
          if (state is Checking) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MethodsError) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 60),
                  Icon(Icons.error_outline,
                      color: Colors.red.shade400, size: 42),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Desliza hacia abajo para reintentar.',
                    style: textTheme.bodySmall!.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          if (state is Complete) {
            final metodos = state.metodos;
            if (metodos.isEmpty) {
              return RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.credit_card_off,
                                          size: 42, color: Colors.grey),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Aún no has agregado métodos de pago.',
                                        style: textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Pulsa el botón + para añadir uno nuevo o desliza para recargar.',
                                        style: textTheme.bodySmall!
                                            .copyWith(color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ))))));
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                itemCount: metodos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = metodos[index];
                  if (item is CardModel) {
                    return CardItem(
                      model: item,
                      onLongPress: () => _confirmDelete(context, 'tarjeta'),
                    );
                  } else if (item is BankAccountModel) {
                    return BankItem(
                      model: item,
                      onLongPress: () =>
                          _confirmDelete(context, 'cuenta bancaria'),
                    );
                  } else {
                    return ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Método desconocido'),
                      subtitle: Text(item.toString()),
                    );
                  }
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String tipo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar $tipo'),
        content: Text('¿Estás seguro de que deseas eliminar esta $tipo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$tipo eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
