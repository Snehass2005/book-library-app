class HttpException implements Exception {
  final String message;
  final int? code;

  HttpException(this.message, {this.code});

  @override
  String toString() {
    if (code != null) {
      return "HttpException: $message (Code: $code)";
    }
    return "HttpException: $message";
  }
}
