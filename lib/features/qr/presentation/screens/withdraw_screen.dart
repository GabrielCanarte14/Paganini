import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/history/presentation/bloc/historial/historial_bloc.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/models.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/widgets.dart';

import 'package:paganini_wallet/features/qr/presentation/bloc/pagos/pagos_bloc.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/bloc/methods/methods_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final ValueNotifier<String> _rawVN = ValueNotifier<String>('0');
  BankAccountModel? _selectedCard;

  void _setRaw(String v) => _rawVN.value = v;

  void _tapDigit(String d) {
    final raw = _rawVN.value;
    if (d == '.') {
      if (raw.contains('.')) return;
      _setRaw(raw.isEmpty ? '0.' : '$raw.');
      return;
    }
    if (raw == '0') {
      _setRaw(d);
      return;
    }
    if (raw.contains('.')) {
      final idx = raw.indexOf('.');
      final decimals = raw.length - idx - 1;
      if (decimals >= 2) return;
    }
    _setRaw('$raw$d');
  }

  void _backspace() {
    var raw = _rawVN.value;
    if (raw.isEmpty) return;
    raw = raw.substring(0, raw.length - 1);
    if (raw.isEmpty || raw == '-') raw = '0';
    if (raw.endsWith('.')) {
      raw = raw.substring(0, raw.length - 1);
      if (raw.isEmpty) raw = '0';
    }
    _setRaw(raw);
  }

  void _applyQuickAmount(double value) {
    final cents = (value * 100).round();
    final normalized = (cents / 100).toStringAsFixed(2);
    _setRaw(normalized);
  }

  @override
  void initState() {
    super.initState();
    context.read<MethodsBloc>().add(GetMethodsEvent(email: widget.email));
  }

  @override
  void dispose() {
    _rawVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<PagosBloc, PagosState>(
          listenWhen: (prev, curr) =>
              curr is Revisando ||
              curr is WithdrawComplete ||
              curr is PaymentError,
          listener: (context, state) {
            if (state is WithdrawComplete) {
              showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.success(
                    message: state.message,
                    backgroundColor: secondaryColor,
                  ));
              context.read<AuthBloc>().add(GetUserDataEvent());
              context.read<HistorialBloc>().add(GetHistorialEvent());
              Navigator.of(context).pop();
            } else if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message,
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<MethodsBloc, MethodsState>(
        builder: (context, mState) {
          final methodsLoading = mState is Checking;
          List<BankAccountModel> cards = const [];
          if (mState is Complete) {
            cards = mState.metodos
                .where((e) => e is BankAccountModel)
                .cast<BankAccountModel>()
                .toList();
            if (_selectedCard == null && cards.isNotEmpty) {
              _selectedCard = cards.first;
            }
          }

          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  titleSpacing: 25,
                  centerTitle: false,
                  title: Text(
                    'Retirar dinero',
                    style:
                        textStyles.titleMedium?.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  backgroundColor: primaryColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      if (mState is MethodsError)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mState.message,
                                style: textStyles.bodyMedium
                                    ?.copyWith(color: Colors.red),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 150,
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reintentar'),
                                  onPressed: () => context
                                      .read<MethodsBloc>()
                                      .add(
                                          GetMethodsEvent(email: widget.email)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (mState is Complete) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                          child: DropdownButtonFormField<BankAccountModel>(
                            decoration: InputDecoration(
                              labelText: 'Cuenta de retiro',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                            value: _selectedCard,
                            items: cards
                                .map(
                                  (c) => DropdownMenuItem<BankAccountModel>(
                                    value: c,
                                    child: Text(c.number,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                )
                                .toList(),
                            onChanged: (c) => setState(() => _selectedCard = c),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      ValueListenableBuilder<String>(
                        valueListenable: _rawVN,
                        builder: (_, raw, __) {
                          final amountStr = formatCurrencyEsFromRaw(raw);
                          return Center(
                            child: AmountDisplay(text: amountStr),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Center(
                          child: QuickAmountChips(
                            amounts: const [10, 20, 50, 100],
                            onTapAmount: (v) => _applyQuickAmount(v.toDouble()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: NumKeypad(
                            decimalVisual: ',',
                            onDigit: _tapDigit,
                            onBackspace: _backspace,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                        child: ValueListenableBuilder<String>(
                          valueListenable: _rawVN,
                          builder: (_, raw, __) {
                            final amount = double.tryParse(raw) ?? 0.0;
                            final pagosLoading =
                                context.watch<PagosBloc>().state is Revisando;

                            final enabled = amount > 0 &&
                                _selectedCard != null &&
                                !pagosLoading &&
                                (mState is Complete);

                            return SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: enabled
                                    ? () {
                                        final methodId = _selectedCard!.id;
                                        context.read<PagosBloc>().add(
                                            WithdrawEvent(
                                                methodId: methodId,
                                                monto: amount));
                                      }
                                    : null,
                                child: const Text(
                                  'Retirar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (methodsLoading ||
                  context.watch<PagosBloc>().state is Revisando)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.12),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
