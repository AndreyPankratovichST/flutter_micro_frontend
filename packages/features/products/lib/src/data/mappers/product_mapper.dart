import 'package:core/core.dart';
import 'package:products/src/data/models/product_model.dart';
import 'package:products/src/domain/entities/product.dart';

final class ProductMapper extends Mapper<Product, ProductModel> {
  @override
  Product toEntity(ProductModel model) {
    return Product(
      id: model.id,
      title: model.title,
      description: model.description,
      price: model.price,
      thumbnail: model.thumbnail,
    );
  }

  @override
  ProductModel toModel(Product entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      thumbnail: entity.thumbnail,
    );
  }
}
