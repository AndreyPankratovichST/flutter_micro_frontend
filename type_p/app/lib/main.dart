import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared/shared.dart';
import 'di.dart';
import 'app.dart';

void main() async {
  // Инициализация Flutter для доступа к нативным API
  WidgetsFlutterBinding.ensureInitialized();

  // Загрузка environment variables в зависимости от build mode
  await dotenv.load(fileName: kReleaseMode ? '.env.prod' : '.env');

  // Настройка зависимостей через get_it
  configureDependencies();

  // Запуск приложения
  runApp(const App());
}