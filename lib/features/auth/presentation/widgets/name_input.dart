import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paganini_wallet/features/auth/presentation/bloc/register_form_cubit.dart';
import 'package:paganini_wallet/features/shared/widgets/custom_text_form_field.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormCubit, RegisterFormState>(
      builder: (context, state) {
        return CustomTextFormField(
          label: 'Nombre',
          keyboardType: TextInputType.name,
          onChanged: (value) =>
              context.read<RegisterFormCubit>().onNameChanged(value),
          errorMessage: state.isFormPosted ? state.name.errorMessage : null,
        );
      },
    );
  }
}
