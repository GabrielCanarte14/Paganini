import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/card_model.dart';

class CardItem extends StatelessWidget {
  final CardModel model;
  final VoidCallback? onLongPress;

  const CardItem({super.key, required this.model, this.onLongPress});

  String _formatExpiry(String? month, String? year) {
    if (month == null || year == null) return '';
    final mm = month.padLeft(2, '0');
    final yy = year.length >= 2 ? year.substring(year.length - 2) : year;
    return '$mm/$yy';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: CreditCardWidget(
        cardNumber: (model.number),
        expiryDate: _formatExpiry(model.month, model.year),
        cardHolderName: model.titular,
        cvvCode: '***',
        showBackView: false,
        isHolderNameVisible: true,
        obscureCardCvv: true,
        obscureCardNumber: true,
        cardBgColor: Colors.black,
        onCreditCardWidgetChange: (brand) {},
      ),
    );
  }
}
