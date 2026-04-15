import 'src/presentation/pages/basket_page.dart';
import 'package:flutter/material.dart';

const title = 'Basket';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: const BasketPage(),
    );
  }
}
