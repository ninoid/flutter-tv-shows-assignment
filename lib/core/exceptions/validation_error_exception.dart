
class ValidationErrorException implements Exception {
  final String errorMessage;
  const ValidationErrorException(this.errorMessage);
}
