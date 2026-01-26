part of 'products_bloc.dart';

sealed class ProductsState {
  const ProductsState();
}

final class ProductsLoadingState extends ProductsState {
  const ProductsLoadingState();
}

final class ProductsLoadedState extends ProductsState {
  final List<Product> products;
  final int countInBasket;

  const ProductsLoadedState({
    required this.products,
    required this.countInBasket,
  });
}

final class ProductsErrorState extends ProductsState {
  final Object error;

  ProductsErrorState(this.error);
}
