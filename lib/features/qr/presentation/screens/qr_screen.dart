import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
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
                      onCode: (code) async {
                        if (_handled) return;
                        _handled = true;
                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('QR detectado'),
                            content: Text(code),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              )
                            ],
                          ),
                        );
                        _handled = false;
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
