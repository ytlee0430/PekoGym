/// Sealed class for explicit success/failure return types in domain layer.
/// Prevents exception leakage through repository boundaries.
sealed class Result<T, E> {
  const Result();
}

/// Represents a successful operation result.
final class Success<T, E> extends Result<T, E> {
  /// Creates a [Success] with the given [value].
  const Success(this.value);

  /// The successful result value.
  final T value;
}

/// Represents a failed operation result.
final class Failure<T, E> extends Result<T, E> {
  /// Creates a [Failure] with the given [error].
  const Failure(this.error);

  /// The error that caused the failure.
  final E error;
}
