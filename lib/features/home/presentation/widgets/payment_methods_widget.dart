import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/constants.dart';

class PaymentMethodsWidget extends StatelessWidget {
  const PaymentMethodsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Tus tarjetas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('Ver todas', style: TextStyle(color: primaryColor)),
          ],
        ),
        const SizedBox(height: 12),
        CreditCard(
          cardNumber: '1234 5678 9012 3456',
          cardExpiry: '12/26',
          cardHolderName: 'Gabriel Cañarte',
          cvv: '123',
          bankName: 'Banco Pichincha',
          cardType: CardType.masterCard,
          showBackSide: false,
          frontBackground: CardBackgrounds.black,
          backBackground: CardBackgrounds.white,
          showShadow: true,
        ),
      ],
    );
  }
}
