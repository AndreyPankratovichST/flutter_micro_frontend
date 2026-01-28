import 'dart:async';

import 'package:basket/src/domain/entities/product.dart';
import 'package:basket/src/domain/usecases/delete_from_basket_usecase.dart';
import 'package:basket/src/domain/usecases/fetch_basket_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'basket_event.dart';
part 'basket_state.dart';

final class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final FetchBasketProductsUseCase _fetchBasketProductsUseCase;
  final DeleteFromBasketUseCase _deleteFromBasketUseCase;

  BasketBloc(this._fetchBasketProductsUseCase, this._deleteFromBasketUseCase)
    : super(const BasketLoadingState()) {
    on<BasketFetchProductsEvent>(_onFetchProducts);
    on<DeleteFromBasketEvent>(_deleteFromBasket);

    add(BasketFetchProductsEvent());
  }

  Future<void> _onFetchProducts(
    BasketFetchProductsEvent event,
    Emitter<BasketState> emit,
  ) async {
    (await _fetchBasketProductsUseCase.call()).fold(
      (result) => emit(BasketLoadedState(result)),
      (error) => emit(BasketErrorState(error)),
    );
  }

  Future<void> _deleteFromBasket(
    DeleteFromBasketEvent event,
    Emitter<BasketState> emit,
  ) async {
    final result = await _deleteFromBasketUseCase.call(event.product);
    if (result.error == null) {
      add(BasketFetchProductsEvent());
    } 
  }
}
