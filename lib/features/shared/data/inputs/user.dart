import 'package:formz/formz.dart';

enum UserError { empty, form }

class User extends FormzInput<String, UserError> {
  const User.pure() : super.pure('');

  const User.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UserError.empty) return 'El campo es requerido';
    if (displayError == UserError.form) {
      return 'No tiene formato de correo';
    }

    return null;
  }

  @override
  UserError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UserError.empty;

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value)) return UserError.form;

    return null;
  }
}
