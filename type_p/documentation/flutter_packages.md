# Архитектура packages Flutter-приложения

## Введение

Это документ описывает архитектуру мобильного приложения на Flutter, предназначенного для крупного проекта (50+ экранов с интеграцией сложных функций, таких как real-time чат, микросервисы или модульные расширения). Приложение предполагает функциональность с авторизацией, профилем пользователя, настройками и возможным расширением.

Архитектура основана на комбинации **Clean Architecture** и **Feature-First подхода**, с модуляризацией на уровне Dart-пакетов для обеспечения масштабируемости. Это позволяет изолировать фичи, минимизировать зависимости и упростить командную разработку. Выбор обоснован современными best practices Flutter-разработки на 2025 год, включая рекомендации официальной документации Flutter (разделение слоев данных и UI), акцент на Clean Architecture для scalable apps и практики для крупных приложений (планирование архитектуры, patterns для scalability).

**Причины выбора именно такой архитектуры:**
- **Масштабируемость:** Для крупного проекта нужна структура, позволяющая добавлять фичи без рефакторинга основного кода. Модуляризация пакетов снижает время сборки и конфликты в команде.
- **Тестируемость и поддержка:** Clean Architecture разделяет concerns (data, domain, presentation), что упрощает unit-тесты и интеграцию.
- **Производительность и чистота кода:** Использование BLoC для state management с reactive streams соответствует рекомендациям по нормализации state и обработке async операций, а pure build functions минимизируют overhead.

## Технологический стек

- **Навигация:** GoRouter — для declarative routing с поддержкой редиректов на основе состояния (например, авторизации). Причина: Упрощает управление сложными маршрутами в растущем приложении, интегрируется с state management.
- **DI:** get_it + injectable (с code generation) — для автоматической инъекции зависимостей. Причина: Минимизирует boilerplate, обеспечивает singleton'ы для глобальных сервисов; идеально для scalable DI в крупных apps.
- **HTTP:** Dio + Retrofit — для сетевых запросов с code generation API. Причина: Автоматизирует генерацию клиентов, добавляет interceptors для auth; эффективно для async операций.
- **State Management:** BLoC — для reactive state с event-driven подходом. Причина: Подходит для complex state в крупных apps; альтернативы как Riverpod возможны, но BLoC обеспечивает предсказуемость.
- **Code Generation:** injectable, retrofit, freezed — для моделей, состояний и DI. Причина: Обеспечивает типобезопасность, immutable data; снижает ошибки в scalable коде.
- **Конфигурация и Env:** flutter_dotenv — для загрузки environment variables из .env файлов. Причина: Позволяет безопасно хранить конфиденциальные данные (API keys, base URLs) вне кода, с поддержкой разных окружений (dev, prod); интегрируется с DI.
- **Логирование:** logger — для централизованного логирования событий и ошибок. Причина: Упрощает отладку и мониторинг в production.
- **Тестирование:** mocktail, flutter_test — для unit, integration и widget тестов. Причина: Обеспечивает надежность кода при масштабировании.
- **Локализация:** Intl — для поддержки многоязычности. Причина: Поддерживает динамическое переключение языков, интегрируется с SettingsBloc.
- **Оффлайн-режим:** Hive — для локального кэширования данных. Причина: Обеспечивает offline-first функциональность.
- **Feature Flags:** firebase_remote_config — для управления функциональностью в runtime. Причина: Позволяет включать/выключать фичи без деплоя.
- **Дополнительно:** rxdart для стримов (BehaviorSubject вместо StreamController для удобства); Sentry для мониторинга ошибок. Причина: Reactive updates для UI, real-time мониторинг для reliability.

## Структура проекта

Проект разделен на основной модуль и Dart-пакеты для изоляции. Это Feature-First с элементами Layer-First в каждой фиче.

```
my_app/
├── lib/
│   ├── main.dart                    # Точка входа, инициализация DI, env и auth check
│   ├── di.dart                     # Глобальная DI-конфигурация (сбор модулей)
│   └── app.dart                    # MyApp с MultiBlocProvider и GoRouter
├── packages/
│   ├── core/                       # Инфраструктура (network, utils, constants)
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── network/       # Dio setup, api_client, interceptors
│   │   │   │   ├── utils/         # Logging, error handling
│   │   │   │   └── constants/     # App-wide constants
│   │   │   ├── di/
│   │   │   │   └── core_module.dart  # DI для core
│   │   │   └── core.dart          # Экспорт API
│   │   └── pubspec.yaml
│   ├── shared/                     # Общие сущности, сервисы, BLoC'и
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── domain/        # Entities, repositories interfaces, usecases
│   │   │   │   ├── data/          # Repositories impl, models/DTO
│   │   │   │   ├── services/      # AuthService, UserService, etc.
│   │   │   │   └── presentation/  # Global BLoC'и, shared widgets
│   │   │   ├── di/
│   │   │   │   └── shared_module.dart  # DI для shared
│   │   │   └── shared.dart        # Экспорт API
│   │   └── pubspec.yaml
│   ├── config/                     # Глобальная конфигурация
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── app_config.dart # Настройки (baseUrl, apiKey)
│   │   │   │   ├── theme.dart      # Темы приложения
│   │   │   │   └── l10n/          # Локализация (.arb файлы)
│   │   │   ├── di/
│   │   │   │   └── config_module.dart # DI для config
│   │   │   └── config.dart        # Экспорт API
│   │   └── pubspec.yaml
│   ├── auth/                       # Фича авторизации
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── domain/        # Feature-specific entities/usecases
│   │   │   │   ├── data/          # Repos impl
│   │   │   │   └── presentation/  # BLoC, pages, widgets
│   │   │   ├── di/
│   │   │   │   └── auth_module.dart  # Локальный DI
│   │   │   └── auth.dart          # Экспорт API
│   │   └── pubspec.yaml
│   ├── profile/                    # Аналогично auth
│   ├── settings/                   # Аналогично auth
│   └── (другие фичи по мере роста)
├── assets/                         # Статические ресурсы (изображения, etc.)
├── .env                            # Environment variables для dev
├── .env.prod                       # Environment variables для prod
└── pubspec.yaml                    # Основной, с зависимостями от пакетов
```

**Причины структуры:**
- **Пакеты для модульности:** Каждая фича — независимый пакет, что снижает coupling и ускоряет build для крупных apps. Shared и core — центральные, для избежания дублирования.
- **Config как отдельный пакет:** Размещение в `packages/config/` обеспечивает полную модульность, независимость от бизнес-логики (shared) и легкость масштабирования (например, добавление feature flags). Это идеально для крупного проекта, где конфигурация может быть сложной (региональные настройки, A/B тестирование).
- **Слои в фичах:** Domain (бизнес-логика), data (данные), presentation (UI) — по Clean Architecture, для separation of concerns.

## Подробное описание компонентов

### 1. Core: Инфраструктура
Содержит низкоуровневый код, не зависящий от бизнес-логики.
- **Network:** Dio с Retrofit для API, настройка клиента для сетевых запросов.
- **Utils:** Logging (logger), error handling, connectivity checks.
- **Constants:** App-wide константы (endpoints, timeouts).
- **DI:** CoreModule регистрирует Dio, ApiClient.

**Пример (ApiClient):**
```dart
@singleton
class ApiClient {
  final Dio _dio;
  final AppConfig _config;

  ApiClient(this._dio, this._config) {
    _dio.options.baseUrl = _config.baseUrl;
    _dio.interceptors.add(LogInterceptor()); // Логирование запросов
  }
}
```

**Причины:** Централизованная обработка сетевых операций и утилит; middleware-подход для async.

### 2. Shared: Общие сервисы и состояние
Центральный хаб для глобального состояния.
- **Domain:** UserEntity, repositories interfaces (UserRepository), usecases (GetCurrentUser).
- **Data:** Impl репозиториев, DTO (UserDto с freezed).
- **Services:** AuthService (auth streams), UserService (user updates).
- **Presentation:** Global BLoC (AppBloc, UserBloc), shared widgets (LoadingIndicator).

**Пример (AuthService):**
```dart
@singleton
class AuthService {
  final UserRepository _userRepository;
  User? _currentUser;
  final _authStatus = BehaviorSubject<AuthStatus>();

  AuthService(this._userRepository);

  Future<void> setUser(User user) async {
    _currentUser = user;
    _authStatus.add(AuthStatus.authenticated);
    await _userRepository.cacheUser(user); // Hive для кэша
    Logger().i('User authenticated: ${user.id}');
  }
  // ... (clearUser, checkAuthStatus)
}
```

**Причины:** Централизованное state для кросс-фич коммуникации; reactive streams для efficiency.

### 3. Config: Глобальная конфигурация
Отдельный пакет для настроек приложения, доступный через DI.
- **app_config.dart:** Класс AppConfig, загружающий значения из env (baseUrl, apiKey).
- **theme.dart:** Темы (AppTheme.light, AppTheme.dark).
- **l10n/:** Локализация (.arb файлы) с Intl.
- **DI:** ConfigModule регистрирует AppConfig.

**Взаимодействие с config:**
- **Загрузка:** В main.dart загружается .env, затем AppConfig инициализируется через DI.
- **Доступ:** Через `getIt<AppConfig>()` в сервисах, BLoC, UI.
- **Использование в UI:** `MaterialApp(theme: getIt<AppConfig>().theme, localizationsDelegates: AppLocalizations.localizationsDelegates)`.
- **Динамическое изменение:** SettingsBloc обновляет AppConfig (например, theme) и эммитит события для rebuild UI.

**Пример (app_config.dart):**
```dart
@singleton
class AppConfig {
  final String baseUrl;
  final String apiKey;
  final ThemeData theme;
  final String locale;

  AppConfig({
    required this.baseUrl,
    required this.apiKey,
    this.theme = AppTheme.light,
    this.locale = 'en',
  });

  factory AppConfig.fromEnv() {
    return AppConfig(
      baseUrl: dotenv.env['BASE_URL'] ?? 'https://api.example.com',
      apiKey: dotenv.env['API_KEY'] ?? '',
    );
  }
}
```

**Причины размещения в packages/config/**: Обеспечивает модульность, тестируемость и независимость от бизнес-логики (shared). Для крупного проекта позволяет добавлять feature flags, региональные настройки или A/B тесты без рефакторинга.

### 4. Features (пример: Auth)
Изолированные модули.
- **Domain/Data:** LoginUseCase, AuthRepositoryImpl.
- **Presentation:** AuthBloc, LoginPage.
- **DI:** AuthModule регистрирует локальные зависимости, используя shared и config.

**Пример use case (LoginUseCase):**
```dart
// packages/auth/lib/src/domain/usecases/login_usecase.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:shared/shared.dart';
import 'package:core/core.dart'; // Для Failure

part 'login_usecase.freezed.dart';

@freezed
class LoginParams with _$LoginParams {
  const factory LoginParams({
    required String email,
    required String password,
  }) = _LoginParams;
}

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    if (params.email.isEmpty || params.password.isEmpty) {
      return Left(ValidationFailure('Invalid credentials'));
    }
    try {
      final response = await _authRepository.login(params.email, params.password);
      return Right(UserEntity.fromDto(response));
    } catch (e) {
      return Left(NetworkFailure('Login failed: $e'));
    }
  }
}
```

**Пример (AuthBloc):**
```dart
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthService _authService;

  AuthBloc(this._loginUseCase, this._authService) : super(AuthInitial());

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _loginUseCase(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) async {
        await _authService.setUser(user);
        emit(AuthSuccess(user));
      },
    );
  }
}
```

**Причины:** Изоляция фич для parallel dev; use cases для бизнес-логики; dartz для типизированных ошибок.

### 5. Навигация и UI
- **GoRouter:** С редиректами на основе AuthService.
- **MyApp:** MultiBlocProvider для глобальных BLoC.

**Пример (app.dart):**
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>.value(value: getIt<AppBloc>()),
        BlocProvider<UserBloc>.value(value: getIt<UserBloc>()),
        BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        theme: getIt<AppConfig>().theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
```

**Причины:** Declarative routing для scalability; reactive UI через BLoC.

### 6. Инициализация
- **main.dart:** Загрузка env, configure DI, check auth, runApp.

**Пример:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared/shared.dart';
import 'di.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: kReleaseMode ? '.env.prod' : '.env');
  configureDependencies();
  await getIt<AuthService>().checkAuthStatus();
  runApp(const MyApp());
}
```

### 7. Env: Работа с environment variables
- **Структура:** .env (dev), .env.prod (prod), .env.staging (опционально).
- **Работа:**
    - Зависимость: `flutter_dotenv: ^5.1.0` в pubspec.yaml (config, core).
    - Загрузка: `await dotenv.load(fileName: kReleaseMode ? '.env.prod' : '.env');` в main.dart.
    - Интеграция: AppConfig в config_module.dart использует `dotenv.env['KEY']`.
    - Безопасность: .env в .gitignore; CI/CD (GitHub Actions) для инъекции env.
    - Тестирование: Моки для dotenv в тестах.
    - Переключение: `flutter build apk --release` использует .env.prod.

**Причины:** Безопасность, поддержка multiple env, интеграция с DI.

### 8. Тестирование
- **Unit тесты**: Для use cases, services, BLoC'и (mocktail для моков).
- **Integration тесты**: Для API (mock Dio), навигации (GoRouter).
- **Widget тесты**: Для UI-компонентов (flutter_test).

**Пример unit теста (LoginUseCase):**
```dart
void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepo;

    setUp(() {
      mockRepo = MockAuthRepository();
      useCase = LoginUseCase(mockRepo);
    });

    test('should return UserEntity on successful login', () async {
      final user = UserEntity(id: '1', email: 'test@example.com');
      when(() => mockRepo.login('test@example.com', 'password'))
          .thenAnswer((_) async => user);

      final result = await useCase(LoginParams(email: 'test@example.com', password: 'password'));

      expect(result, Right(user));
    });
  });
}
```

**Причины:** Обеспечивает надежность кода, упрощает рефакторинг.

### 9. Логирование и мониторинг
- **Логирование:** logger для локальных логов; Sentry для production мониторинга.
- **Интеграция:** В core/utils/logging.dart:
  ```dart:disable-run
  @singleton
  class AppLogger {
    final Logger _logger = Logger();

    void info(String message) => _logger.i(message);
    void error(String message, [dynamic error, StackTrace? stackTrace]) {
      _logger.e(message, error, stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
  ```

**Причины:** Централизованное логирование для отладки; Sentry для real-time мониторинга.

### 10. Обработка ошибок
- **Типизированные ошибки:** Используем dartz и custom Failure классы.
- **Пример (core):**
  ```dart
  @freezed
  class Failure with _$Failure {
    const factory Failure.network(String message) = NetworkFailure;
    const factory Failure.validation(String message) = ValidationFailure;
    const factory Failure.server(String message) = ServerFailure;
  }
  ```
- **В UI:** AuthBloc эммитит AuthError с message из Failure для отображения в UI.

**Причины:** Упрощает обработку и отображение ошибок в UI.

### 11. Локализация
- **Динамическое переключение:** SettingsBloc обновляет locale в AppConfig.
- **Пример (SettingsBloc):**
  ```dart
  class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
    final AppConfig _config;

    SettingsBloc(this._config) : super(SettingsState(locale: _config.locale)) {
      on<ChangeLocale>((event, emit) {
        _config.locale = event.locale;
        emit(SettingsState(locale: event.locale));
      });
    }
  }
  ```

**Причины:** Поддержка многоязычности для глобальных приложений.

### 12. Оффлайн-режим и кэширование
- **Кэширование:** Hive для хранения UserEntity, settings.
- **Стратегия:** Репозитории проверяют connectivity (core/utils/connectivity.dart); при offline возвращают кэшированные данные.
- **Пример (UserRepository):**
  ```dart
  Future<UserEntity?> getCachedUser() async {
    final box = await Hive.openBox('user');
    return box.get('current_user') as UserEntity?;
  }
  ```

**Причины:** Обеспечивает offline-first функциональность.

### 13. Feature Flags
- **Инструмент:** firebase_remote_config.
- **Пример:** В AppConfig:
  ```dart
  Future<void> initFeatureFlags() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    _featureFlags = {'chat_enabled': remoteConfig.getBool('chat_enabled')};
  }
  ```

**Причины:** Управление функциональностью без деплоя.

### 14. CI/CD и деплой
- **Инструменты:** GitHub Actions для сборки, тестирования, деплоя.
- **Процесс:**
    - Unit тесты: `flutter test`.
    - Build: `flutter build apk --release`.
    - Env инъекция: Secrets в CI/CD для .env.prod.
    - Deploy: Fastlane для App Store/Google Play.

**Причины:** Автоматизация для large-scale разработки.

## Преимущества

| Аспект | Преимущество | Обоснование |
|--------|-------------|-------------|
| Масштабируемость | Легкое добавление фич | Пакеты + Feature-First |
| Тестируемость | Моки для репозиториев | Clean слои |
| Производительность | Reactive state, pure functions | Best practices |
| Поддержка | Изоляция, DI, Env | Для команд |
| Конфигурация | Отдельный пакет config | Модульность и независимость |
| Надежность | Тестирование, логирование, ошибки | Для production |

## Заключение

Эта архитектура идеально подходит для крупного проекта, обеспечивая модульность через пакеты (включая config), изоляцию фич и централизованное управление состоянием. Config в packages/config/ гарантирует масштабируемость и чистоту. Дополнения (тестирование, логирование, feature flags) обеспечивают надежность и гибкость. Для реализации начните с настройки CI/CD, тестов и Sentry.
```