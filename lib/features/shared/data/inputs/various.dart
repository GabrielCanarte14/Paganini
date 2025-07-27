import 'package:formz/formz.dart';

enum Error { empty, hasNumber, invalidFormat, tooLong }

class Name extends FormzInput<String, Error> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  Error? validator(String value) {
    if (value.trim().isEmpty) return Error.empty;
    if (RegExp(r'[0-9]').hasMatch(value)) return Error.hasNumber;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == Error.empty) return 'El campo es requerido';
    if (displayError == Error.hasNumber) return 'No debe contener números';
    return null;
  }
}

class Lastname extends FormzInput<String, Error> {
  const Lastname.pure() : super.pure('');
  const Lastname.dirty([String value = '']) : super.dirty(value);

  @override
  Error? validator(String value) {
    if (value.trim().isEmpty) return Error.empty;
    if (RegExp(r'[0-9]').hasMatch(value)) return Error.hasNumber;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == Error.empty) return 'El campo es requerido';
    if (displayError == Error.hasNumber) return 'No debe contener números';
    return null;
  }
}

class Phone extends FormzInput<String, Error> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([String value = '']) : super.dirty(value);

  @override
  Error? validator(String value) {
    if (value.trim().isEmpty) return Error.empty;
    if (!RegExp(r'^\d+$').hasMatch(value)) return Error.invalidFormat;
    if (value.length > 10) return Error.tooLong;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == Error.empty) return 'El campo es requerido';
    if (displayError == Error.invalidFormat) return 'Solo se permiten números';
    if (displayError == Error.tooLong) return 'Máximo 10 dígitos';
    return null;
  }
}
