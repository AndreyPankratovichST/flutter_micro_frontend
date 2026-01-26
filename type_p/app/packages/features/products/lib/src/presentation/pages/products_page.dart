import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products/src/presentation/blocs/products/products_bloc.dart';
import 'package:products/src/presentation/widgets/basket_button.dart';
import 'package:products/src/presentation/widgets/error_view.dart';
import 'package:products/src/presentation/widgets/loading_view.dart';
import 'package:products/src/presentation/widgets/products_list_view.dart';

const titleText = 'Products';
const spacing = 8.0;

final class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsBloc>(
      create: (_) => di.get(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(titleText),
          actionsPadding: EdgeInsets.symmetric(horizontal: spacing),
          actions: [
            BlocBuilder<ProductsBloc, ProductsState>(
              builder: (_, state) {
                final count = state is ProductsLoadedState
                    ? state.countInBasket
                    : 0;
                return BasketButton(countInBasket: count);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (_, state) {
              return switch (state) {
                ProductsLoadingState() => const LoadingView(),
                ProductsLoadedState() => ProductsListView(
                  products: state.products,
                ),
                ProductsErrorState() => ErrorView(error: state.error),
              };
            },
          ),
        ),
      ),
    );
  }
}
