import 'package:formz/formz.dart';

enum UserError { empty, length }

class User extends FormzInput<String, UserError> {
  const User.pure() : super.pure('');

  const User.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UserError.empty) return 'El campo es requerido';
    if (displayError == UserError.length) {
      return 'No tiene formato de usuario';
    }

    return null;
  }

  @override
  UserError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UserError.empty;
    if (value.length < 3) return UserError.length;

    return null;
  }
}
