import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/scan_button_widget.dart';

class ScannerView extends StatelessWidget {
  final MobileScannerController controller;
  final ValueChanged<String> onCode;

  const ScannerView({
    super.key,
    required this.controller,
    required this.onCode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            if (barcodes.isEmpty) return;
            final raw = barcodes.first.rawValue;
            if (raw == null) return;
            onCode(raw);
          },
        ),
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
        Positioned(
          bottom: 28,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScanButton(
                icon: Icons.cameraswitch_rounded,
                onTap: () => controller.switchCamera(),
              ),
              ScanButton(
                icon: Icons.flash_on_rounded,
                onTap: () => controller.toggleTorch(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
