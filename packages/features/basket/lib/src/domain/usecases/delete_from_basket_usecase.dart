import 'package:basket/src/domain/entities/product.dart';
import 'package:basket/src/domain/repositories/basket_repository.dart';
import 'package:core/core.dart';

class DeleteFromBasketUseCase implements UseCase<Null, Product> {
  final BasketRepository _repository;

  DeleteFromBasketUseCase(this._repository);

  @override
  Future<Result<Null>> call([Product? product]) async {
    try {
      await _repository.deleteFromBasket(product!);
      return Result(result: null);
    } catch (e) {
      return Result(error: e);
    }
  }
}
