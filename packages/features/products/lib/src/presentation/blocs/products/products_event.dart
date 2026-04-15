part of 'products_bloc.dart';

sealed class ProductsEvent {
  const ProductsEvent();
}

final class ProductsFetchEvent extends ProductsEvent {
  const ProductsFetchEvent();
}

final class ProductsBasketCountFetchEvent extends ProductsEvent {
  const ProductsBasketCountFetchEvent();
}

final class ProductToBasketEvent extends ProductsEvent {
  final Product product;

  ProductToBasketEvent(this.product);
}
