import 'package:app/app/app.dart';
import 'package:app/config/config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configurationApp();

  runApp(const App());
}
