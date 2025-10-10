### **Архитектура Flutter-приложения с **feature-first** подходом**

### **Структура проекта**
```
lib/
├── core/                 # Общие компоненты, не зависящие от фич
│   ├── constants/        # Константы (строки, цвета, стили)
│   ├── utils/            # Утилиты и хелперы
│   ├── widgets/          # Переиспользуемые базовые виджеты
│   ├── services/         # Сервисы (API, навигация, локальное хранилище)
│   ├── errors/           # Обработка ошибок и исключения
│   └── theme/            # Тема приложения
├── features/             # Фичи (основная директория)
│   ├── feature_a/        # Пример фичи
│   │   ├── data/         # Data-слой
│   │   │   ├── datasources/  # Источники данных (локальные/удаленные)
│   │   │   ├── models/       # DTO и модели данных
│   │   │   └── repositories/ # Имплементации репозиториев
│   │   ├── domain/       # Business-логика
│   │   │   ├── entities/     # Бизнес-сущности
│   │   │   ├── repositories/ # Абстракции репозиториев
│   │   │   └── usecases/     # Сценарии использования (интеракторы)
│   │   └── presentation/ # UI-слой
│   │       ├── bloc/         # State management (или Cubit/Provider)
│   │       ├── widgets/      # Локальные виджеты фичи
│   │       └── pages/        # Страницы/экраны
│   └── feature_b/        # Другая фича (аналогичная структура)
├── app/                  # Инициализация приложения
│   ├── di/              # Dependency Injection (get_it, injectable)
│   └── app_widget.dart  # Корневой виджет
└── main.dart            # Точка входа
```

---

### **Принципы и правила**
1. **Изоляция фич**:
    - Фичи не знают друг о друге
    - Общение через Events/DI/Route
    - Возможность независимой разработки и тестирования

2. **Слои внутри фичи**:
    - **Data**: Работа с данными (API, БД)
    - **Domain**: Чистая бизнес-логика (без зависимостей от Flutter)
    - **Presentation**: UI и состояние экранов

3. **Направление зависимостей**:
   ```
   Presentation → Domain ← Data
   ```

---

### **Ключевые компоненты**

#### **1. Data Layer**
```dart
// datasources/remote_data_source.dart
abstract class RemoteDataSource {
  Future<UserModel> getUser(int id);
}

// models/user_model.dart
@JsonSerializable()
class UserModel {
  final int id;
  final String name;
}

// repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource _remoteDataSource;
  
  @override
  Future<User> getUser(int id) async {
    final model = await _remoteDataSource.getUser(id);
    return model.toEntity();
  }
}
```

#### **2. Domain Layer**
```dart
// entities/user.dart
class User {
  final int id;
  final String name;
}

// repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(int id);
}

// usecases/get_user.dart
class GetUser {
  final UserRepository repository;
  
  GetUser(this.repository);
  
  Future<User> call(int id) => repository.getUser(id);
}
```

#### **3. Presentation Layer**
```dart
// bloc/user_bloc.dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser getUserUseCase;

  UserBloc(this.getUserUseCase) : super(UserInitial()) {
    on<FetchUser>((event, emit) async {
      emit(UserLoading());
      final result = await getUserUseCase(event.id);
      emit(UserLoaded(result));
    });
  }
}
```

---

### **Dependency Injection (get_it)**
```dart
// di/injectable.config.dart
@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class FeatureModule {
  @lazySingleton
  UserRepository get userRepo => UserRepositoryImpl(getIt());
  
  @factoryParam
  UserBloc userBloc(int id) => UserBloc(getIt(param1: id));
}
```

---

### **Навигация**
Используйте генерацию маршрутов (auto_route) или параметризованные подходы:
```dart
// В рамках фичи - локальная навигация
// Между фичами - через общий роутер
Navigator.pushNamed(context, '/featureA/details');
```

---

### **Тестирование**
```
test/
├── features/
│   ├── feature_a/
│   │   ├── data/         # Тесты репозиториев
│   │   ├── domain/       # Тесты use cases
│   │   └── presentation/ # BLoC тесты
```

Пример теста BLoC:
```dart
void main() {
  late UserBloc bloc;
  late MockGetUserUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetUserUseCase();
    bloc = UserBloc(mockUseCase);
  });

  test('emits [Loading, Loaded] when successful', () {
    when(mockUseCase(any)).thenAnswer((_) async => User(...));
    
    expectLater(
      bloc.stream,
      emitsInOrder([UserLoading(), UserLoaded(...)]),
    );
    
    bloc.add(FetchUser(1));
  });
}
```

---

### **Преимущества архитектуры**
1. **Масштабируемость** — новые фичи добавляются изолированно
2. **Тестируемость** — каждый компонент тестируется отдельно
3. **Сопровождаемость** — четкое разделение ответственности
4. **Работа в команде** — разные разработчики могут работать над разными фичами
5. **Переиспользование** — общие компоненты в core/

Эта архитектура проверена в продакшене и позволяет комфортно работать над проектами любой сложности с командой от 1 до 20+ разработчиков.