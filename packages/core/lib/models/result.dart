/// Erro de domínio/transporte tratado de forma segura pelo app.
class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'AppException($statusCode): $message';
}

/// Resultado seguro: [Success] com dado ou [Failure] com [AppException].
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final data) => data,
        Failure<T>() => null,
      };

  AppException? get errorOrNull => switch (this) {
        Success<T>() => null,
        Failure<T>(:final error) => error,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) =>
      switch (this) {
        Success<T>(:final data) => success(data),
        Failure<T>(:final error) => failure(error),
      };

  /// Transforma o dado de sucesso; erros de parsing viram [Failure].
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success<T>(:final data) => _guard(() => transform(data)),
        Failure<T>(:final error) => Failure<R>(error),
      };

  static Result<R> _guard<R>(R Function() body) {
    try {
      return Success<R>(body());
    } catch (_) {
      return Failure<R>(const AppException('Resposta inesperada do servidor.'));
    }
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppException error;
}
