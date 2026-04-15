import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products/src/presentation/blocs/products/products_bloc.dart';

const basketPath = '/basket';

final class BasketButton extends StatelessWidget {
  final int countInBasket;
  const BasketButton({super.key, required this.countInBasket});

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: countInBasket,
      child: IconButton(
        onPressed: () => di
            .get<AppRouter>()
            .push(basketPath)
            .then(
              (_) => context.mounted
                  ? context.read<ProductsBloc>().add(ProductsFetchEvent())
                  : null,
            ),
        icon: Icon(Icons.shopping_basket_outlined),
      ),
    );
  }
}
