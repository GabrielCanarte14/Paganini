import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../shared/data/inputs/inputs.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(const RegisterFormState());

  void onNameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate(
          [name, state.lastname, state.email, state.phone, state.password]),
    ));
  }

  void onLastnameChanged(String value) {
    final lastname = Lastname.dirty(value);
    emit(state.copyWith(
      lastname: lastname,
      isValid: Formz.validate(
          [state.name, lastname, state.email, state.phone, state.password]),
    ));
  }

  void onEmailChanged(String value) {
    final email = User.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate(
          [state.name, state.lastname, email, state.phone, state.password]),
    ));
  }

  void onPhoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
      isValid: Formz.validate(
          [state.name, state.lastname, state.email, phone, state.password]),
    ));
  }

  void onPasswordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate(
          [state.name, state.lastname, state.email, state.phone, password]),
    ));
  }

  void touchEveryField() {
    final name = Name.dirty(state.name.value);
    final lastname = Lastname.dirty(state.lastname.value);
    final email = User.dirty(state.email.value);
    final phone = Phone.dirty(state.phone.value);
    final password = Password.dirty(state.password.value);

    emit(state.copyWith(
      isFormPosted: true,
      name: name,
      lastname: lastname,
      email: email,
      phone: phone,
      password: password,
      isValid: Formz.validate([name, lastname, email, phone, password]),
    ));
  }
}

class RegisterFormState extends Equatable {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Lastname lastname;
  final User email;
  final Phone phone;
  final Password password;

  const RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(),
    this.lastname = const Lastname.pure(),
    this.email = const User.pure(),
    this.phone = const Phone.pure(),
    this.password = const Password.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Lastname? lastname,
    User? email,
    Phone? phone,
    Password? password,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        password: password ?? this.password,
      );

  @override
  List<Object> get props => [
        isPosting,
        isFormPosted,
        isValid,
        name,
        lastname,
        email,
        phone,
        password
      ];
}
