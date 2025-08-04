import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class PaymentMethodsWidget extends StatelessWidget {
  final PersistentTabController controller;

  const PaymentMethodsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tus tarjetas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () {
                controller.jumpToTab(3);
              },
              child: Text('Ver todas', style: TextStyle(color: primaryColor)),
            ),
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
