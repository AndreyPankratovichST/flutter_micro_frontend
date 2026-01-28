import 'package:basket/src/domain/entities/product.dart';
import 'package:basket/src/presentation/blocs/basket/basket_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

const spacing = 8.0;
const flexImage = 2;
const flexPrice = 1;

const fractionDigits = 2;
const removeText = 'Delete';

final class BasketProductView extends StatelessWidget {
  final Product product;

  const BasketProductView({super.key, required this.product});

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
                child: ItemImage(url: product.thumbnail ?? ''),
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
                      onPressed: () => context.read<BasketBloc>().add(
                        DeleteFromBasketEvent(product),
                      ),
                      child: Text(removeText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
