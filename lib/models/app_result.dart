/// Simple Either-like wrapper for repository results.
sealed class AppResult<T> {
  const AppResult();
  R match<R>({required R Function(T) ok, required R Function(Object, StackTrace?) err});
}

class Ok<T> extends AppResult<T> {
  final T value;
  const Ok(this.value);
  @override
  R match<R>({required R Function(T) ok, required R Function(Object, StackTrace?) err}) => ok(value);
}

class Err<T> extends AppResult<T> {
  final Object error;
  final StackTrace? stack;
  const Err(this.error, [this.stack]);
  @override
  R match<R>({required R Function(T) ok, required R Function(Object, StackTrace?) err}) => err(error, stack);
}
