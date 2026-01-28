import 'package:basket/src/data/models/product_model.dart';

abstract class BasketLocalDataSource {
  Future<List<ProductModel>> fetchBasketProducts();

  Future<void> deleteFromBasket(ProductModel model);
}
