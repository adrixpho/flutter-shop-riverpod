class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String errorMessage;
  final int codeError;

  CustomError({
    required this.errorMessage,
    this.codeError = 0,
  });
}
