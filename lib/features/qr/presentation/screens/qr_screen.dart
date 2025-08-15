import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/bloc/pagos/pagos_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/confirm_payment_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/payment_ammount_screen.dart';
import 'package:paganini_wallet/features/qr/presentation/screens/views/views.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/widgets.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  QrTab _tab = QrTab.myCode;
  final MobileScannerController _scannerCtrl = MobileScannerController();
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetUserDataEvent());
  }

  @override
  void dispose() {
    _scannerCtrl.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String s) {
    final v = s.trim();
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(v);
  }

  _PayReq? _tryParsePayReq(String raw) {
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      if (map['t']?.toString() != 'PAYREQ') return null;

      final email = map['c']?.toString();
      final mStr = map['m']?.toString();
      final pid = map['pid'];

      if (email == null || mStr == null || pid == null) return null;

      final amount = double.tryParse(mStr.replaceAll(',', '.'));
      final providerId = (pid is int) ? pid : int.tryParse(pid.toString());

      if (amount == null || providerId == null) return null;
      return _PayReq(email: email, amount: amount, providerId: providerId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _handleCode(String code) async {
    if (_handled) return;
    _handled = true;

    await _scannerCtrl.stop();
    final content = code.trim();
    final pr = _tryParsePayReq(content);
    if (pr != null) {
      if (!mounted) return;
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ConfirmTransferScreen(
            email: pr.email,
            amount: pr.amount,
            name: '',
            onConfirm: () {
              context.read<PagosBloc>().add(
                    QrAmountPaymentEvent(monto: pr.amount, payload: code),
                  );
            },
          ),
        ),
      );
      _handled = false;
      await _scannerCtrl.start();
      return;
    }

    if (_looksLikeEmail(content)) {
      if (!mounted) return;
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => SendMoneyScreen(
            name: '',
            email: content,
            qr: true,
          ),
        ),
      );
      _handled = false;
      await _scannerCtrl.start();
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR no reconocido')),
      );
      _handled = false;
      await _scannerCtrl.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _tab == QrTab.myCode ? 'Mi QR' : 'Escanear';
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SegmentedControl(
            leftLabel: 'Mi código',
            rightLabel: 'Escanear',
            tab: _tab,
            onChanged: (t) => setState(() => _tab = t),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _tab == QrTab.myCode
                  ? const MyQrView()
                  : ScannerView(
                      controller: _scannerCtrl,
                      onCode: _handleCode,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayReq {
  final String email;
  final double amount;
  final int providerId;
  _PayReq(
      {required this.email, required this.amount, required this.providerId});
}
