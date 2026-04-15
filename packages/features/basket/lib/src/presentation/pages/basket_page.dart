import 'package:basket/src/presentation/blocs/basket/basket_bloc.dart';
import 'package:basket/src/presentation/widgets/basket_products_view.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

const titleText = 'Basket';

final class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BasketBloc>(
      create: (context) => di.get(),
      child: Scaffold(
        appBar: AppBar(title: Text(titleText)),
        body: SafeArea(
          child: BlocBuilder<BasketBloc, BasketState>(
            builder: (context, state) {
              return switch (state) {
                BasketLoadingState() => LoadingView(),
                BasketErrorState() => ErrorView(error: state.error),
                BasketLoadedState() => BasketProductsView(
                  products: state.products,
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}
