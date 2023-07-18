import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

// PROVIDER
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginCallback: loginCallback);
});

// State
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      email: $email
      password: $password
    ''';
  }

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password);
  }
}

// Notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Future<void> Function(String, String)? loginCallback;

  LoginFormNotifier({
    this.loginCallback,
  }) : super(LoginFormState());

  void emailChanged(String value) {
    final emailInput = Email.dirty(value);
    state = state.copyWith(
      email: emailInput,
      isValid: Formz.validate(
        [
          emailInput,
          state.password,
        ],
      ),
    );
  }

  void passwordChanged(String value) {
    final passwordInput = Password.dirty(value);
    state = state.copyWith(
      password: passwordInput,
      isValid: Formz.validate(
        [
          passwordInput,
          state.email,
        ],
      ),
    );
  }

  void onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    if (loginCallback != null) {
      await loginCallback!(state.email.value, state.password.value);
    }
    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate(
          [
            email,
            password,
          ],
        ));
  }
}
