import 'package:core/core.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/repositories/products_repository.dart';

class AddToBasketUseCase implements UseCase<Null, Product> {
  final ProductsRepository _repository;

  AddToBasketUseCase(this._repository);

  @override
  Future<Result<Null>> call([Product? product]) async {
    try {
      await _repository.addToBasket(product!);
      return Result(result: null);
    } catch (e) {
      return Result(error: e);
    }
  }
}
