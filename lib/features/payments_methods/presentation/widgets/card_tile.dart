import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:paganini_wallet/features/payments_methods/data/model/card_model.dart';

class CardItem extends StatelessWidget {
  final CardModel model;
  final VoidCallback? onLongPress;
  const CardItem({super.key, required this.model, this.onLongPress});

  String _mask(String num) {
    if (num.length < 4) return num;
    final last4 = num.substring(num.length - 4);
    return '**** **** **** $last4';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: CreditCard(
        cardNumber: model.number,
        cardExpiry:
            '${model.month!.toString().padLeft(2, '0')}/${model.year!.toString().substring(2)}',
        cardHolderName: model.titular,
        cvv: '***',
        bankName: '',
        cardType: CardType.visa,
        showBackSide: false,
        frontBackground: CardBackgrounds.black,
        backBackground: CardBackgrounds.white,
        showShadow: true,
      ),
    );
  }
}
