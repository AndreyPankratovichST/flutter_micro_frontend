import 'package:flutter/material.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/presentation/widgets/product_view.dart';

const emptyText = 'List is empty';

final class ProductsListView extends StatelessWidget {
  final List<Product> products;
  const ProductsListView({super.key, required this.products});

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
        return ProductView(key: ValueKey(product.id), product: product);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
