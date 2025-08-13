import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/utils.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/confirm_payment_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/widgets.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({
    super.key,
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text(
          'Enviar dinero',
          style: textStyles.titleMedium!.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(widget.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(widget.email,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black45)),
            const SizedBox(height: 16),
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
                amounts: const [50, 100, 200, 300],
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
                      onPressed: amount > 0
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ConfirmTransferScreen(
                                    name: widget.name,
                                    email: widget.email,
                                    amount: amount,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        'Enviar dinero',
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
    );
  }
}
