import 'package:core/core.dart';
import 'package:flutter/material.dart';

const basketPath = '/basket';

final class BasketButton extends StatelessWidget {
  final int countInBasket;
  const BasketButton({super.key, required this.countInBasket});

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: countInBasket,
      child: IconButton(
        onPressed: () => di.get<AppRouter>().push(basketPath),
        icon: Icon(Icons.shopping_basket_outlined),
      ),
    );
  }
}
