import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/core/theme/theme.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/register_form_cubit.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';

class RegisterPasswordInput extends StatelessWidget {
  final bool icon;
  const RegisterPasswordInput({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormCubit, RegisterFormState>(
        builder: (context, state) {
      return CustomTextFormField(
          key: const Key('login_password_input'),
          icon: icon
              ? UiUtils.getSvg(AppIcons.lock,
                  color: Colors.black38, width: 20.rf(context))
              : null,
          label: 'Contraseña',
          obscureText: true,
          onChanged: (value) {
            context.read<RegisterFormCubit>().onPasswordChanged(value);
          },
          errorMessage:
              state.isFormPosted ? state.password.errorMessage : null);
    });
  }
}
