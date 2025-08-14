import 'package:paganini_wallet/core/constants/typedefs.dart';
import 'package:paganini_wallet/features/qr/domain/entities/qr_payload.dart';

class QrPayloadModel extends QrPayload {
  const QrPayloadModel({
    required super.payload,
    required super.qrBase64,
    required super.ammount,
  });

  factory QrPayloadModel.fromJson(Json json) {
    return QrPayloadModel(
      payload: json['payload'],
      qrBase64: json['qrBase64'],
      ammount: json['monto'] ?? 0.00,
    );
  }

  Json toJson() {
    return {
      'payload': payload,
      'qrBase64': qrBase64,
      'monto': ammount,
    };
  }
}
