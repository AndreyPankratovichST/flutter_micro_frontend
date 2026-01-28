import 'package:basket/src/data/datasources/basket_local_datasource.dart';
import 'package:basket/src/data/models/product_model.dart';
import 'package:core/core.dart';

const _basketKey = 'basket';

final class BasketLocalDataSourceImpl implements BasketLocalDataSource {
  final AppStorage _storage;

  BasketLocalDataSourceImpl(this._storage);

  @override
  Future<List<ProductModel>> fetchBasketProducts() async {
    final data = await _storage.get<List<dynamic>>(_basketKey);

    return data?.map((e) => ProductModel.fromJson(e)).toList() ?? [];
  }

  @override
  Future<void> deleteFromBasket(ProductModel model) async {
    final data = await _storage.get<List<dynamic>>(_basketKey);
    if (data == null) {
      return;
    }

    final elementIndex = data.indexWhere((e) => ProductModel.fromJson(e).id == model.id);
    final updatedData = data..removeAt(elementIndex);
    await _storage.set(_basketKey, updatedData);
  }
}
