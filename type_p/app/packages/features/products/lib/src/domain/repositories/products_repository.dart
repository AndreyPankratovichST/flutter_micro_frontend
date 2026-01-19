import 'package:products/src/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> fetchProducts();
}