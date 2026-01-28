import 'package:basket/src/domain/entities/product.dart';

abstract class BasketRepository {
  Future<List<Product>> fetchBasketProducts();
  Future<void> deleteFromBasket(Product product);
}