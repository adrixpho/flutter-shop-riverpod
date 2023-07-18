import 'package:formz/formz.dart';

// Define input validation errors
enum TextInputError { empty }

// Extend FormzInput and provide the input type and error type.
class TextInput extends FormzInput<String, TextInputError> {
  // Call super.pure to represent an unmodified form input.
  const TextInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const TextInput.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TextInputError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TextInputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return TextInputError.empty;

    return null;
  }
}
