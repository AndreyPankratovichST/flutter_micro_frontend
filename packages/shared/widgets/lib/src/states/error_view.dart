import 'package:flutter/material.dart';

final class ErrorView extends StatelessWidget {
  final Object error;

  const ErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error.toString(),
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
