typedef ResultBuilder<R> = void Function(R);
typedef ErrorBuilder = void Function(Object);

class Result<R> {
  final R? result;
  final Object? error;

  Result({this.result, this.error});

  void fold(ResultBuilder<R> onResult, [ErrorBuilder? onError]) {
    final failure = error;
    if (failure != null) {
      onError?.call(failure);
      return;
    }

    final value = result;
    if (value != null) {
      onResult(value);
      return;
    }
  }

  static Future<Result<List>> from(List<Future<Result>> calls) async {
    final list = <dynamic>[];
    for (var call in calls) {
      final result = await call;
      if (result.error != null) {
        return Result(error: result.error);
      }
      list.add(result.result);
    }

    return Result(result: list);
  }
}
