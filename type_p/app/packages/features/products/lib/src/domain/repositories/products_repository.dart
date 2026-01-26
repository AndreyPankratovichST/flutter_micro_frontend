import 'package:products/src/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> fetchProducts();

  Future<int> getProductsBasketCount();

  Future<void> addToBasket(Product product);
}