import 'package:core/core.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: di.get<AppRouter>().router,
      debugShowCheckedModeBanner: false,
    );
  }
}
