import 'package:products/src/data/models/product_model.dart';

abstract class ProductsLocalDataSource {
  Future<List<ProductModel>> fetchProducts();

  Future<void> saveProducts(List<ProductModel> products);

  Future<void> addToBasket(ProductModel model);

  Future<int> getProductsBasketCount();
}
