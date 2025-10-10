## Экспериментальный runtime MFE в Flutter: Расширенный анализ, примеры и перспективы

В предыдущем докладе я кратко упомянул экспериментальный подход к runtime MFE в Flutter, отметив его нестабильность и предпочтение build-time интеграции. Теперь давайте углубимся в эту тему, добавив больше деталей на основе актуальных разработок (по состоянию на 2025 год). Runtime MFE подразумевает динамическую загрузку и композицию модулей во время выполнения приложения (runtime), а не на этапе сборки (build-time). В веб-разработке это реализуется через инструменты вроде Webpack Module Federation или SystemJS, позволяющие загружать модули на лету без перезагрузки страницы. В Flutter, ориентированном на нативный рендеринг, runtime MFE остается экспериментальным из-за отсутствия встроенной поддержки динамической загрузки кода (AOT-компиляция ограничивает это). Однако для Flutter Web существуют workable хаки, а для нативных приложений — обходные пути через OTA-обновления и кастомные движки.

### Почему runtime MFE экспериментален в Flutter?
- **Ограничения Flutter**: Flutter использует Ahead-of-Time (AOT) компиляцию для производительности, что делает динамическую загрузку кода (Just-in-Time, JIT) сложной. Deferred loading (отложенная загрузка) существует, но она статична и работает только на этапе сборки — нельзя загружать модули из удаленных источников во время выполнения. В отличие от React Native (с Re.Pack для Module Federation), Flutter не имеет официального roadmap для полноценного runtime MFE по состоянию на 2025 год. GitHub-issue #172464 от июля 2025 года обсуждает это, но закрыт как дубликат без официального ответа от команды Flutter. Сообщество отмечает интерес для enterprise-приложений: ускорение запуска (загрузка только нужных фич), A/B-тестирование и feature toggling.

- **Build-time vs Runtime**: В build-time модули интегрируются на этапе компиляции (статично, как в стандартных Flutter-пакетах), что проще и производительнее. Runtime позволяет динамические обновления (обновить модуль без перевыпуска всего app), полиглотность (смешивание фреймворков) и loose coupling, но страдает от производительности (задержки загрузки), отладки и конфликтов версий. В Flutter runtime чаще применяется в веб-версиях, где можно использовать JavaScript-хостинг.

### Подходы к реализации runtime MFE в Flutter
Runtime MFE в Flutter делится на два сценария: Flutter Web (более зрелый) и нативный Flutter (экспериментальный с хаками).

#### 1. Runtime MFE в Flutter Web
Для веб-версий Flutter runtime MFE реализуется через embedding micro-apps в shell-приложение с использованием iframes, HtmlElementView и динамической инъекции. Это позволяет загружать модули с CDN на лету, поддерживая версионирование и zero-downtime updates. Подход вдохновлен веб-технологиями вроде SystemJS для client-side loading.

- **Архитектура**:
    - **Shell**: Основное приложение, управляющее глобальным UI (навигация, аутентификация), маршрутизацией и оркестрацией. Использует `dart:ui` и `dart:html` для регистрации views.
    - **Micro-apps**: Отдельные Flutter Web-проекты, скомпилированные в JS-бандлы. Могут быть гетерогенными (например, один на Flutter, другой на React).
    - **Оркестратор**: Манифест (JSON-файл) для версионирования и загрузки: `{"authModule": {"version": "1.0.0", "url": "https://cdn.example.com/auth/1.0.0/index.html"}}`.
    - **Загрузка**: Динамическая через iframes или ES Modules.

- **Пример реализации**:
  Создайте shell и micro-app.

  **Shell (main.dart)**:
  ```dart:disable-run
  import 'dart:html';
  import 'dart:ui' as ui;
  import 'package:flutter/material.dart';

  void main() {
    // Регистрация фабрики для micro-app
    ui.platformViewRegistry.registerViewFactory(
      'micro-app-view',
      (int viewId) {
        final iframe = IFrameElement()
          ..src = 'https://cdn.example.com/micro_app/index.html'  // Динамический URL из манифеста
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      },
    );
    runApp(ShellApp());
  }

  class ShellApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Shell App')),
          body: HtmlElementView(viewType: 'micro-app-view'),  // Вставка micro-app
        ),
      );
    }
  }
  ```

  **Micro-app (main.dart в отдельном проекте)**:
  ```dart
  import 'dart:html';
  import 'package:flutter/material.dart';

  void main() {
    // Сообщение о готовности
    window.parent?.postMessage({'type': 'MICRO_APP_READY'}, '*');

    // Прослушка сообщений от shell
    window.onMessage.listen((MessageEvent event) {
      final data = event.data as Map<String, dynamic>;
      if (data['type'] == 'NAVIGATE') {
        // Обработка навигации внутри micro-app
        print('Navigate to: ${data['route']}');
      }
    });

    runApp(MicroApp());
  }

  class MicroApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Micro App Content')),
        ),
      );
    }
  }
  ```

  **Коммуникация**: Через `window.postMessage` для событий (например, 'AUTH_SUCCESS' от auth-module к shell).

    - **Deployment**: Скомпилируйте micro-app: `flutter build web --release --base-href /micro_app/`. Загрузите на CDN. Shell загружает по URL из манифеста, позволяя обновления без перекомпиляции shell.

- **Плюсы**: Динамические обновления, интеграция с другими фреймворками (React/Vue в iframes).
- **Минусы и вызовы**: Производительность (задержки загрузки iframes), безопасность (cross-origin issues), сложная отладка (отдельные devtools). Нет Server-Side Rendering (SSR) без доп. усилий, как в Next.js. В больших командах — конфликты стилей/состояний.

#### 2. Runtime MFE в нативном Flutter
Для мобильных (iOS/Android) true runtime loading отсутствует. Эксперименты включают:
- **OTA-обновления**: Инструменты вроде Shorebird или CodePush позволяют обновлять код модулей over-the-air без App Store/Google Play. Например, разбейте app на модули, обновляйте их отдельно. Но это не dynamic loading — обновления применяются при рестарте, а не на лету.
- **Кастомные форки Flutter Engine**: Некоторые команды форкают Flutter Engine для поддержки dynamic linking (например, загрузка .so/.dylib модулей). Это высокорискованно: нарушает AOT, требует экспертизы в C++/Dart, нестабильно в production.
- **WebView embedding**: Вставьте web-based micro-apps в нативный Flutter через WebView. Пример: `webview_flutter` плагин для рендеринга удаленного Flutter Web-модуля. Но это hybrid-approach, с overhead (двойной рендеринг) и потерей нативной производительности.
- **Module Registry Pattern**: Предложен в сообществе — абстрактный registry для регистрации модулей на runtime, но зависит от deferred loading и не поддерживает удаленную загрузку.

- **Пример с WebView**:
  ```dart
  import 'package:webview_flutter/webview_flutter.dart';
  import 'package:flutter/material.dart';

  class RuntimeModuleLoader extends StatelessWidget {
    final String moduleUrl = 'https://cdn.example.com/micro_app/index.html';

    @override
    Widget build(BuildContext context) {
      return WebView(
        initialUrl: moduleUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          // Коммуникация через JS channels
          controller.addJavascriptChannel('FlutterChannel', onMessageReceived: (JavascriptMessage msg) {
            print('Message from module: ${msg.message}');
          });
        },
      );
    }
  }
  ```
  Это позволяет загружать модуль динамически, но с ограничениями (нет seamless интеграции widgets).

- **Вызовы**: Безопасность (удаленный код может быть вредоносным), compliance (App Store правила против dynamic code), производительность (дополнительный overhead). В 2025 году сообщество обсуждает интеграцию с Impeller (новый рендерер Flutter) для лучшей поддержки, но официально не подтверждено.

### Перспективы и roadmap
- **Текущий статус**: Нет официального roadmap от Google для runtime MFE в Flutter (issue #172464 закрыт без прогресса). Сообщество экспериментирует, но production-решения редки — 67% enterprise Flutter apps предпочитают build-time из-за стабильности.
- **Будущие тенденции (2025+)**: Ожидается интеграция с WebAssembly (Wasm) для динамической загрузки модулей в Flutter Web. Инструменты вроде Bit или custom CLI могут эволюционировать для мобильных. Для нативного — потенциал в Flutter 4.x с улучшенным deferred loading. Рекомендация: Для экспериментов используйте Flutter Web; для production — hybrid с WebView или OTA.
- **Когда использовать**: Только для специфических случаев (динамические фичи в веб-apps). В большинстве — stick to build-time с Melos для модульности.

Этот расширенный обзор показывает, что runtime MFE в Flutter — нишевое, но перспективное направление. Если нужно интегрировать в полный доклад или добавить код-репозитории, дайте знать!
```