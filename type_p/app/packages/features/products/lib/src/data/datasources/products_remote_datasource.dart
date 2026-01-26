import 'package:products/src/data/models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}
