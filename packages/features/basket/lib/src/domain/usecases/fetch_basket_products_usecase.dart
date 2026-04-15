import 'package:basket/src/domain/entities/product.dart';
import 'package:basket/src/domain/repositories/basket_repository.dart';
import 'package:core/core.dart';

class FetchBasketProductsUseCase implements UseCase<List<Product>, Null> {
  final BasketRepository _repository;

  FetchBasketProductsUseCase(this._repository);

  @override
  Future<Result<List<Product>>> call([Null params]) async {
    try {
      return Result(result: await _repository.fetchBasketProducts());
    } catch (e) {
      return Result(error: e);
    }
  }
}
