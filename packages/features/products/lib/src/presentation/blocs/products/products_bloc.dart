import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/domain/usecases/add_to_basket_usecase.dart';
import 'package:products/src/domain/usecases/fetch_products_usecase.dart';
import 'package:products/src/domain/usecases/get_products_basket_count_usecase.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final FetchProductsUseCase _fetchProductsUseCase;
  final GetProductsBasketCountUseCase _basketCountUseCase;
  final AddToBasketUseCase _addToBasketUseCase;

  ProductsBloc(
    this._fetchProductsUseCase,
    this._basketCountUseCase,
    this._addToBasketUseCase,
  ) : super(const ProductsLoadingState()) {
    on<ProductsFetchEvent>(_onFetchProducts);
    on<ProductsBasketCountFetchEvent>(_onFetchBasketCountProducts);
    on<ProductToBasketEvent>(_addProductToBasket);

    add(ProductsFetchEvent());
  }

  Future<void> _onFetchProducts(
    ProductsFetchEvent event,
    Emitter<ProductsState> emit,
  ) async {
    (await Result.from([_fetchProductsUseCase(), _basketCountUseCase()])).fold(
      (result) => emit(
        ProductsLoadedState(products: result[0], countInBasket: result[1]),
      ),
      (error) => emit(ProductsErrorState(error)),
    );
  }

  FutureOr<void> _onFetchBasketCountProducts(
    ProductsBasketCountFetchEvent event,
    Emitter<ProductsState> emit,
  ) async {
    (await _basketCountUseCase()).fold((result) {
      final currentState = state;
      if (currentState is ProductsLoadedState) {
        emit(
          ProductsLoadedState(
            products: currentState.products,
            countInBasket: result,
          ),
        );
      }
    });
  }

  Future<void> _addProductToBasket(
    ProductToBasketEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final result = (await _addToBasketUseCase(event.product));
    if (result.error == null) {
      add(ProductsFetchEvent());
    }
  }
}
