import 'package:basket/src/domain/entities/product.dart';
import 'package:basket/src/presentation/widgets/basket_product_view.dart';
import 'package:flutter/material.dart';

const emptyText = 'Basket is empty';

final class BasketProductsView extends StatelessWidget {
  final List<Product> products;
  const BasketProductsView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text(emptyText, style: Theme.of(context).textTheme.displaySmall),
      );
    }
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return BasketProductView(key: ValueKey(product.id), product: product);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
