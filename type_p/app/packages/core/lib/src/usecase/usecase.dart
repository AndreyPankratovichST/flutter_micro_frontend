import 'package:core/src/usecase/result.dart';

abstract class UseCase<R, P> {
  Future<Result<R>> call([P? params]);
}
