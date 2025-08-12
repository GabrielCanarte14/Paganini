import 'dart:convert';
import 'package:flutter/material.dart';

class UserQrImage extends StatelessWidget {
  final String qrBase64;
  final double size;

  const UserQrImage({
    super.key,
    required this.qrBase64,
    this.size = 260,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final normalized = base64.normalize(qrBase64);
      final bytes = base64Decode(normalized);

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => const Text('QR inválido'),
          ),
        ),
      );
    } catch (_) {
      return const Text('No se pudo decodificar el QR');
    }
  }
}
