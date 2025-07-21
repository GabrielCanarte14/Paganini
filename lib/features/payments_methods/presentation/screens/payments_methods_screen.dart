import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/payments_methods/presentation/widgets/add_method_modal.dart';

class PaymentsMethodsScreen extends StatelessWidget {
  const PaymentsMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text('Métodos de pago',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (context) => const AddMethodModal(),
              );
            },
          ),
        ],
      ),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: ListView(children: [
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
      ]),
    );
  }
}
