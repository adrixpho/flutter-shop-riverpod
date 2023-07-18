import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import '../../../shared/infrastructure/inputs/inputs.dart';
import '../../../shared/infrastructure/inputs/text_input.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerFunction = ref.read(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUser: registerFunction);
});

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final TextInput fullName;
  final Email email;
  final Password password;
  final Password confirmPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.fullName = const TextInput.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
  });

  @override
  String toString() {
    return '''
    RegisterFormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      fullName: $fullName
      email: $email
      password: $password
      confirmPassword: $confirmPassword
    ''';
  }

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    TextInput? fullName,
    Email? email,
    Password? password,
    Password? confirmPassword,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Future<void> Function(String email, String password, String fullName)?
      registerUser;

  RegisterFormNotifier({
    this.registerUser,
  }) : super(RegisterFormState());

  void fullNameChanged(String value) {
    final fullName = TextInput.dirty(value);

    state = state.copyWith(
        fullName: fullName,
        isValid: Formz.validate(
          [
            fullName,
            state.email,
            state.password,
            state.confirmPassword,
          ],
        ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
        email: email,
        isValid: Formz.validate(
          [
            email,
            state.fullName,
            state.password,
            state.confirmPassword,
          ],
        ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmPassword = Password.dirty(
      state.confirmPassword.value,
      passwordReference: password.value,
    );

    state = state.copyWith(
        password: password,
        isValid: Formz.validate(
          [
            state.fullName,
            state.email,
            password,
            confirmPassword,
          ],
        ));
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = Password.dirty(
      value,
      passwordReference: state.password.value,
    );

    state = state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate(
          [
            state.fullName,
            state.email,
            state.password,
            confirmPassword,
          ],
        ));
  }

  void submitForm() {
    _touchEveryField();

    if (state.isValid && registerUser != null) {
      registerUser!(
        state.email.value,
        state.password.value,
        state.fullName.value,
      );
    }
  }

  void _touchEveryField() {
    final fullName = TextInput.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value,
        passwordReference: password.value);

    state = state.copyWith(
        isFormPosted: true,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        isValid: Formz.validate(
          [
            fullName,
            email,
            password,
            confirmPassword,
          ],
        ));
  }
}
