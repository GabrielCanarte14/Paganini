import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/core/theme/theme.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/register_form_cubit.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';

class RegisterUserInput extends StatelessWidget {
  final bool icon;
  const RegisterUserInput({
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormCubit, RegisterFormState>(
      builder: (context, state) {
        return CustomTextFormField(
          icon: icon
              ? UiUtils.getSvg(
                  AppIcons.user,
                  color: Colors.black38,
                  width: 20.rf(context),
                )
              : null,
          label: 'Correo',
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<RegisterFormCubit>().onEmailChanged(value);
          },
          errorMessage: state.isFormPosted ? state.email.errorMessage : null,
        );
      },
    );
  }
}
