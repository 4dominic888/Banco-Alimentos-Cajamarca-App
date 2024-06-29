class Result<T> {
  final bool success;
  final T? data;
  final String? message;

  Result({required this.success, required this.data, required this.message});
  Result.success({required this.data}) : success = true, message = null;
  Result.onError({required this.message}) : success = false, data = null;

}