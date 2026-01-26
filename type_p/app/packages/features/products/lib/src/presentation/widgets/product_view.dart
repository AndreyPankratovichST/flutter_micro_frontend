import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products/src/domain/entities/product.dart';
import 'package:products/src/presentation/blocs/products/products_bloc.dart';

const spacing = 8.0;
const flexImage = 2;
const flexPrice = 1;

const fractionDigits = 2;
const buyText = 'Buy';

final class ProductView extends StatelessWidget {
  final Product product;

  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing,
        children: [
          Text(product.title, style: theme.textTheme.titleLarge),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing,
            children: [
              Expanded(
                flex: flexImage,
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail ?? '',
                  fit: BoxFit.fill,
                  errorWidget: (_, _, _) {
                    return Center(child: Icon(Icons.error_outline));
                  },
                ),
              ),
              Flexible(
                flex: flexPrice,
                child: Column(
                  spacing: spacing,
                  children: [
                    Text(
                      product.price.toStringAsFixed(fractionDigits),
                      style: theme.textTheme.headlineLarge,
                    ),
                    OutlinedButton(
                      onPressed: () => context.read<ProductsBloc>().add(
                        ProductToBasketEvent(product),
                      ),
                      child: Text(buyText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(product.description, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
