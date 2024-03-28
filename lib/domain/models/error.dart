abstract class Failure {
  const Failure();
}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);
}

class RetrievedError extends CustomException {
  RetrievedError(super.message);
}

class InvalidReading extends CustomException {
  InvalidReading(super.message);
}
