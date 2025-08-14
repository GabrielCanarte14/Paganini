import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/models.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/widgets/widgets.dart';

class PaymentMethodsWidget extends StatefulWidget {
  final PersistentTabController controller;

  final String? email;

  const PaymentMethodsWidget({
    super.key,
    required this.controller,
    this.email,
  });

  @override
  State<PaymentMethodsWidget> createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  @override
  void initState() {
    super.initState();
    if (widget.email != null && widget.email!.isNotEmpty) {
      context.read<MethodsBloc>().add(GetMethodsEvent(email: widget.email!));
    }
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tus métodos', style: titleStyle),
            TextButton(
              onPressed: () => widget.controller.jumpToTab(3),
              child: Text('Ver todas', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
        BlocBuilder<MethodsBloc, MethodsState>(
          builder: (context, state) {
            if (state is Checking || state is MethodsInitial) {
              return _CardShimmer(anim: _shimmerCtrl);
            }
            if (state is MethodsError) {
              return Text(
                'No se pudieron cargar los métodos.\nDesliza para reintentar.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              );
            }
            if (state is Complete) {
              final all = state.metodos;
              if (all.isEmpty) {
                return Text(
                  'No hay métodos de pago agregados.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black54),
                );
              }
              final cards = all.whereType<CardModel>().toList();
              final banks = all.whereType<BankAccountModel>().toList();
              final List<Widget> tiles = [];
              if (cards.isNotEmpty) {
                tiles.add(CardItem(model: cards.first));
              }
              if (banks.isNotEmpty) {
                tiles.add(Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: BankItem(model: banks.first),
                ));
              }
              if (tiles.length == 1) {
                if (cards.isNotEmpty && cards.length >= 2) {
                  tiles.add(Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CardItem(model: cards[1]),
                  ));
                } else if (banks.isNotEmpty && banks.length >= 2) {
                  tiles.add(Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: BankItem(model: banks[1]),
                  ));
                }
              }

              return Column(
                children: [
                  SizedBox(
                    height: 210,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.9),
                      padEnds: false,
                      itemCount: tiles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == tiles.length - 1 ? 0 : 12,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 210,
                            child: tiles[index],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _CardShimmer extends StatelessWidget {
  final Animation<double> anim;
  const _CardShimmer({required this.anim});

  @override
  Widget build(BuildContext context) {
    final base = Colors.grey.shade300;
    final highlight = Colors.grey.shade100;

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        final t = anim.value;
        return Container(
          height: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * t, -0.3),
              end: Alignment(1 + 2 * t, 0.3),
              colors: [base, highlight, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}
