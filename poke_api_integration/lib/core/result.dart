sealed class Result<T> {
  const Result._();

  factory Result.success(T data) = Success<T>;

  factory Result.failure(String message, {int? statusCode}) = Failure<T>;
}

class Success<T> extends Result<T> {
  const Success(this.data) : super._();

  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.message, {this.statusCode}) : super._();

  final String message;
  final int? statusCode;
}
