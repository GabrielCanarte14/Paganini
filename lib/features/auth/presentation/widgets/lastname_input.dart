import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/register_form_cubit.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_text_form_field.dart';

class LastnameInput extends StatelessWidget {
  const LastnameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormCubit, RegisterFormState>(
      builder: (context, state) {
        return CustomTextFormField(
          label: 'Apellido',
          keyboardType: TextInputType.name,
          onChanged: (value) =>
              context.read<RegisterFormCubit>().onLastnameChanged(value),
          errorMessage: state.isFormPosted ? state.lastname.errorMessage : null,
        );
      },
    );
  }
}
