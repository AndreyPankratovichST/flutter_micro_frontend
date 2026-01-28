part of 'basket_bloc.dart';

sealed class BasketState {
  const BasketState();
}

final class BasketLoadingState extends BasketState {
  const BasketLoadingState();
}

final class BasketLoadedState extends BasketState {
  final List<Product> products;

  const BasketLoadedState(this.products);
}

final class BasketErrorState extends BasketState {
  final Object error;

  const BasketErrorState(this.error);
}
