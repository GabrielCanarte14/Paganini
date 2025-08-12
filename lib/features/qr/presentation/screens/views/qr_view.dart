import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/qr/presentation/widgets/user_qr_widget.dart';

class MyQrView extends StatelessWidget {
  const MyQrView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) => c is UserInfo || c is UserError || c is GetInfo,
      builder: (context, state) {
        if (state is GetInfo) {
          return const Center(child: CircularProgressIndicator());
        }

        String? b64;
        String name = '';

        if (state is UserInfo) {
          b64 = state.user.base64;
          name = state.user.firstName;
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: UserQrImage(qrBase64: b64!),
                ),
                const SizedBox(height: 18),
                Text(
                  'Muestra este código para recibir pagos${name.isNotEmpty ? ', $name' : ''}.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
