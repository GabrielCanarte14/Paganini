// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/core/theme/theme.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/login_form_cubit.dart';
import 'package:paganini_wallet/features/auth/presentation/widgets/widgets.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_buttom_2.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(resizeToAvoidBottomInset: false, body: _LoginForm());
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    showTopSnackBar(
        Overlay.of(context), CustomSnackBar.error(message: message));
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is UserError) {
          showSnackbar(context, state.message);
        }

        if (state is Authenticated) {
          final loginState = context.read<LoginFormCubit>().state;
        }
      },
      builder: (context, state) {
        final checkingRequest = state is Checking || state is Authenticated;

        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: primaryColor),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        "assets/img/paganini_icono_morado.png",
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10.rh(context)),
                          Text(
                            'BIENVENIDO',
                            style: textStyles.bodyLarge!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Por favor, ingresa tus credenciales',
                            style: textStyles.bodyMedium!.copyWith(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50.rh(context)),
                          const UserInput(),
                          SizedBox(height: 20.rh(context)),
                          const PasswordInput(),
                          SizedBox(height: 30.rh(context)),
                          checkingRequest
                              ? UiUtils.progress()
                              : SizedBox(
                                  width: double.infinity,
                                  child: CustomButtonWidget(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      final cubit =
                                          context.read<LoginFormCubit>();
                                      cubit.touchEveryField();
                                      final state = cubit.state;
                                      if (state.isValid) {
                                        final username = state.usuario.value;
                                        final password = state.password.value;
                                        context.read<AuthBloc>().add(LoginEvent(
                                              username: username,
                                              password: password,
                                            ));
                                      }
                                    },
                                    color: primaryColor,
                                    label: 'Ingresar',
                                    isEnabled: true,
                                  ),
                                ),
                          SizedBox(height: 20.rh(context)),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "¿Olvidaste tu clave?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.rh(context)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "¿No tienes cuenta? ",
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Regístrate",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
