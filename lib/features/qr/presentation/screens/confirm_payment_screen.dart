import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/bloc/pagos/pagos_bloc.dart';

class ConfirmTransferScreen extends StatelessWidget {
  const ConfirmTransferScreen({
    super.key,
    required this.name,
    required this.email,
    required this.amount,
    this.date,
    this.paymentMethod = 'Saldo de la cuenta',
  });

  final String name;
  final String email;
  final double amount;
  final DateTime? date;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final DateTime fecha = date ?? DateTime.now();

    return BlocConsumer<PagosBloc, PagosState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        if (state is PaymentComplete) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: state.message),
          );
          context.read<AuthBloc>().add(GetUserDataEvent());
          Future.microtask(() {
            int pops = 0;
            final nav = Navigator.of(context);
            while (pops < 3 && nav.canPop()) {
              nav.pop();
              pops++;
            }
          });
        } else if (state is PaymentError) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.message),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is Revisando;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 25,
            centerTitle: false,
            title: Text(
              'Enviar dinero a',
              style: textStyles.titleMedium!.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    ConfirmTransferHeader(name: name, email: email),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: const SectionTitle('Medio de pago'),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: PaymentMethodCard(text: paymentMethod),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: const SectionTitle('Detalle de la transacción'),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TransactionDetails(date: fecha, amount: amount),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                      child: SubmitButton(
                        isLoading: isLoading,
                        onPressed: () {
                          context.read<PagosBloc>().add(
                                PaymentEvent(correo: email, monto: amount),
                              );
                        },
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  ModalBarrier(
                    color: Colors.black.withOpacity(0.1),
                    dismissible: false,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
