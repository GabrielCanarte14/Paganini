import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/register_form_cubit.dart';
import 'package:paganini_wallet/features/auth/presentation/widgets/register_user_input.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 25,
          centerTitle: false,
          title: Text(
            'Crear cuenta',
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
        body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is UserError) {
            showSnackbar(context, state.message);
          }
          if (state is Register) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: state.mensaje,
                backgroundColor: secondaryColor,
              ),
            );
            Navigator.pop(context);
          }
        }, builder: (context, state) {
          final checkingRequest = state is Registering;

          return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
              child: Column(children: [
                const SizedBox(height: 20),
                const NameInput(),
                const SizedBox(height: 15),
                const LastnameInput(),
                const SizedBox(height: 15),
                const RegisterUserInput(icon: false),
                const SizedBox(height: 15),
                const PhoneInput(),
                const SizedBox(height: 15),
                const RegisterPasswordInput(icon: false),
                const SizedBox(height: 25),
                checkingRequest
                    ? UiUtils.progress()
                    : SizedBox(
                        width: double.infinity,
                        child: CustomButtonWidget(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            final cubit = context.read<RegisterFormCubit>();
                            cubit.touchEveryField();
                            final state = cubit.state;
                            if (state.isValid) {
                              context.read<AuthBloc>().add(
                                    RegisterEvent(
                                      name: state.name.value,
                                      lastname: state.lastname.value,
                                      email: state.email.value,
                                      phone: state.phone.value,
                                      password: state.password.value,
                                    ),
                                  );
                            }
                          },
                          color: primaryColor,
                          label: 'Registrarse',
                          isEnabled: true,
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "¿Ya tienes cuenta? Inicia sesión",
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ))
              ]));
        }));
  }
}
