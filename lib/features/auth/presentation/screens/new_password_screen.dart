import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/screens/login_screen.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_text_form_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: _NewPasswordScreenForm(),
    );
  }
}

class _NewPasswordScreenForm extends StatefulWidget {
  const _NewPasswordScreenForm();

  @override
  State<_NewPasswordScreenForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_NewPasswordScreenForm> {
  final _codeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _showError(BuildContext context, String message) {
    showTopSnackBar(
        Overlay.of(context), CustomSnackBar.error(message: message));
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        centerTitle: false,
        title: Text(
          'Restablecer contraseña',
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
          if (state is UserError) _showError(context, state.message);
          if (state is Actualizado) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(message: state.mensaje),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is Checking;
          final String? successMsg = state is Register ? state.mensaje : null;
          return Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingresa el código que te enviamos, tu correo y define tu nueva contraseña.',
                  style: textStyles.bodyMedium!.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  label: 'Código',
                  hint: 'Ej: 394201',
                  textEditingController: _codeCtrl,
                  keyboardType: TextInputType.number,
                  sombra: false,
                  border: 15,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  label: 'Correo electrónico',
                  hint: 'ejemplo@correo.com',
                  textEditingController: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  sombra: false,
                  border: 15,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  label: 'Nueva contraseña',
                  hint: '••••••••',
                  textEditingController: _passCtrl,
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
                      style: textStyles.bodyMedium!.copyWith(
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    label: isLoading ? 'Procesando...' : 'Confirmar cambio',
                    color: primaryColor,
                    isEnabled: !isLoading,
                    onTap: () {
                      final code = _codeCtrl.text.trim();
                      final email = _emailCtrl.text.trim();
                      final pass = _passCtrl.text.trim();
                      if (code.isEmpty) {
                        return _showError(context, 'Ingresa el código');
                      }
                      if (email.isEmpty) {
                        return _showError(context, 'Ingresa tu correo');
                      }
                      if (pass.length < 6) {
                        return _showError(context,
                            'La contraseña debe tener al menos 6 caracteres');
                      }
                      context.read<AuthBloc>().add(
                            ResetPasswordEvent(
                                codigo: code, email: email, password: pass),
                          );
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
