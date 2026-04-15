import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

final class ItemImage extends StatelessWidget {
  final String url;
  const ItemImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fill,
      errorWidget: (_, _, _) {
        return Center(child: Icon(Icons.error_outline));
      },
    );
  }
}
