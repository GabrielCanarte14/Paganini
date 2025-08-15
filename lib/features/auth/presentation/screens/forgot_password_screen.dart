import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/screens/new_password_screen.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_text_form_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: _ForgotPasswordForm(),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm();

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  void showError(BuildContext context, String message) {
    showTopSnackBar(
        Overlay.of(context), CustomSnackBar.error(message: message));
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text(
          'Recuperar contraseña',
          style: textStyles.titleMedium!.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserError) {
            showError(context, state.message);
          }
          if (state is Aprovado) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(message: state.mensaje),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NewPasswordScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is Comprobando;
          final String? successMsg = state is Register ? state.mensaje : null;

          return Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Ingresa tu correo electrónico registrado y te enviaremos un código para restablecer tu contraseña.',
                  style: textStyles.bodyMedium!.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  label: 'Correo electrónico',
                  hint: 'ejemplo@correo.com',
                  textEditingController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  sombra: false,
                  border: 15,
                ),
                const SizedBox(height: 20),
                if (successMsg != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      successMsg,
                      style: textStyles.bodyMedium!
                          .copyWith(color: const Color(0xFF2E7D32)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    label: isLoading ? 'Enviando...' : 'Enviar',
                    color: primaryColor,
                    isEnabled: !isLoading,
                    onTap: () {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        showError(context, 'Por favor ingresa tu correo');
                        return;
                      }
                      context
                          .read<AuthBloc>()
                          .add(ForgotPasswordEvent(email: email));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
