import 'package:equatable/equatable.dart';

class QrPayload extends Equatable {
  final String payload;
  final String qrBase64;
  final double ammount;

  const QrPayload({
    required this.payload,
    required this.qrBase64,
    this.ammount = 0,
  });

  @override
  List<Object?> get props => [payload];
}
