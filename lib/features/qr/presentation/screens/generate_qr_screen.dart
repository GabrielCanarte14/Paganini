import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/amount_qr_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/widgets.dart';
import 'package:paganini_wallet/features/qr/presentation/bloc/pagos/pagos_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GenerateQrScreen extends StatefulWidget {
  const GenerateQrScreen({
    super.key,
    this.quickAmounts = const [50, 100, 200, 300],
    this.onGenerate,
    this.onQrReady,
  });

  final List<int> quickAmounts;
  final void Function(double amount)? onGenerate;
  final void Function(String qr)? onQrReady;

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  final ValueNotifier<String> _rawVN = ValueNotifier<String>('0');

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
  void dispose() {
    _rawVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return BlocConsumer<PagosBloc, PagosState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        if (state is AmountQrComplete) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QrPaymentScreen(data: state.qr),
            ),
          );
        } else if (state is PaymentError) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.message),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is Revisando;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 25,
            centerTitle: false,
            title: Text(
              'Recibir dinero',
              style: textStyles.titleMedium!.copyWith(color: Colors.white),
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
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 24),
                    ValueListenableBuilder<String>(
                      valueListenable: _rawVN,
                      builder: (_, raw, __) {
                        final amountStr = formatCurrencyEsFromRaw(raw);
                        return AmountDisplay(text: amountStr);
                      },
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: QuickAmountChips(
                        amounts:
                            widget.quickAmounts.map((e) => e.toInt()).toList(),
                        onTapAmount: (v) => _applyQuickAmount(v.toDouble()),
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
                          return SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: (amount > 0 && !isLoading)
                                  ? () {
                                      context.read<PagosBloc>().add(
                                            GenerateAmountQrEvent(
                                                monto: amount),
                                          );
                                      if (widget.onGenerate != null) {
                                        widget.onGenerate!(amount);
                                      }
                                    }
                                  : null,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.6,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Generar QR',
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
                if (isLoading)
                  ModalBarrier(
                    color: Colors.black.withOpacity(0.1),
                    dismissible: false,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
