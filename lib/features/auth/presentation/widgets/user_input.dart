import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import 'package:paganini_wallet/core/theme/theme.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/bloc.dart';
import 'package:paganini_wallet/features/shared/widgets/widgets.dart';

class UserInput extends StatelessWidget {
  const UserInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginFormState>(
      builder: (context, state) {
        return CustomTextFormField(
          icon: UiUtils.getSvg(
            AppIcons.user,
            color: Colors.black38,
            width: 20.rf(context),
          ),
          label: 'Correo',
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<LoginFormCubit>().onUsernameChange(value);
          },
          errorMessage: state.isFormPosted ? state.usuario.errorMessage : null,
        );
      },
    );
  }
}
