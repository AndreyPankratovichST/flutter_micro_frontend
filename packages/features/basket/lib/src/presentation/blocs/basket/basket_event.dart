part of 'basket_bloc.dart';

sealed class BasketEvent {
  const BasketEvent();
}

final class BasketFetchProductsEvent extends BasketEvent {
  const BasketFetchProductsEvent();
}

final class DeleteFromBasketEvent extends BasketEvent {
  final Product product;

  const DeleteFromBasketEvent(this.product);
}
