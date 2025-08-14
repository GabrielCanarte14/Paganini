import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/qr/data/model/qr_payload_model.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

class QrPaymentScreen extends StatelessWidget {
  final QrPayloadModel data;

  const QrPaymentScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final monto = NumberFormat.currency(locale: 'es_EC', symbol: r'$')
        .format(data.ammount);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text(
          'Qr de pago',
          style: text.titleMedium?.copyWith(color: Colors.white),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: UserQrImage(qrBase64: data.qrBase64, size: 350),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Comparte este Qr para recibir tu pago',
                    style: text.bodyMedium?.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Terminar',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        final cleaned = data.qrBase64.split(',').last.trim();
                        final bytes = base64Decode(cleaned);
                        final mime = lookupMimeType('', headerBytes: bytes) ??
                            'image/png';
                        await SharePlus.instance.share(
                          ShareParams(
                            subject: 'QR de pago',
                            files: [
                              XFile.fromData(
                                bytes,
                                name: 'qr_pago.png',
                                mimeType: mime,
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.ios_share, color: Colors.white),
                      label: const Text(
                        'Compartir',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
