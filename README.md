# Rick and Morty Characters App

Мобильное приложение на Flutter для просмотра персонажей из мультсериала "Рик и Морти" с поддержкой избранного и оффлайн-режима.

## Возможности

- Просмотр списка персонажей из Rick and Morty API
- Добавление персонажей в избранное
- Оффлайн-режим с кешированием данных
- Пагинация с автоматической подгрузкой
- Поддержка светлой и темной темы
- Анимации при добавлении/удалении из избранного
- Pull-to-refresh для обновления данных
- Сортировка избранных (по имени, статусу, виду)
- Swipe-to-delete в избранном

## Технологический стек

### State Management
- **flutter_bloc** (^8.1.6) - BLoC паттерн для управления состоянием
- **equatable** (^2.0.5) - Упрощение сравнения объектов

### Сетевое взаимодействие
- **dio** (^5.7.0) - HTTP клиент
- **retrofit** (^4.4.1) - Type-safe REST client
- **json_annotation** (^4.9.0) - JSON сериализация

### Локальное хранилище
- **drift** (^2.20.3) - SQLite ORM для Flutter
- **sqlite3_flutter_libs** (^0.5.24) - SQLite нативные библиотеки
- **path_provider** (^2.1.4) - Доступ к файловой системе

### UI/UX
- **cached_network_image** (^3.4.1) - Кеширование изображений
- **shimmer** (^3.0.0) - Эффект загрузки
- **Material 3** - Современный дизайн

### Архитектура
- **get_it** (^8.0.2) - Dependency Injection
- Clean Architecture
- Repository Pattern

## Структура проекта

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart          # Настройка зависимостей
│   └── theme/
│       └── app_theme.dart          # Конфигурация тем
├── data/
│   ├── api/
│   │   └── api_client.dart         # REST API клиент
│   ├── database/
│   │   └── database.dart           # SQLite база данных
│   ├── models/
│   │   └── character_model.dart    # Модели данных
│   └── repository/
│       └── character_repository.dart # Репозиторий
├── presentation/
│   ├── bloc/
│   │   ├── characters/
│   │   │   └── characters_bloc.dart # BLoC для списка персонажей
│   │   ├── favorites/
│   │   │   └── favorites_bloc.dart  # BLoC для избранного
│   │   └── theme/
│   │       └── theme_bloc.dart      # BLoC для темы
│   ├── screens/
│   │   ├── characters_screen.dart   # Экран списка персонажей
│   │   ├── favorites_screen.dart    # Экран избранного
│   │   └── home_screen.dart         # Главный экран с навигацией
│   └── widgets/
│       └── character_card.dart      # Карточка персонажа
└── main.dart                         # Точка входа
```

## Установка и запуск

### Требования
- Flutter SDK: ^3.9.0
- Dart SDK: ^3.9.0

### Инструкция по установке

1. Клонируйте репозиторий:
```bash
git clone <repository-url>
cd test_effective_mobile
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Сгенерируйте необходимые файлы (API клиент, модели, база данных):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Запустите приложение:
```bash
flutter run
```

### Для production сборки:

Android:
```bash
flutter build apk --release
```

iOS:
```bash
flutter build ios --release
```

## API

Приложение использует [Rick and Morty API](https://rickandmortyapi.com/documentation/)

Основные эндпоинты:
- `GET /character` - Получение списка персонажей с пагинацией
- `GET /character/{id}` - Получение конкретного персонажа

## Особенности реализации

### Оффлайн режим
Все загруженные персонажи автоматически кешируются в локальную базу данных SQLite. При отсутствии интернета приложение отображает данные из кеша.

### Избранное
Избранные персонажи хранятся в локальной базе данных и доступны даже без интернета. Поддерживается сортировка по различным параметрам.

### Пагинация
Реализована ленивая загрузка: новые персонажи подгружаются автоматически при прокрутке до конца списка.

### Темная тема
Поддержка светлой и темной темы с возможностью переключения через FloatingActionButton.

### Анимации
- Анимация масштабирования звездочки при добавлении в избранное
- Hero анимация для изображений персонажей
- Swipe-to-delete анимация в избранном

## Возможные улучшения

- [ ] Детальная страница персонажа с полной информацией
- [ ] Поиск персонажей по имени
- [ ] Фильтры по статусу, виду, полу
- [ ] Поддержка локализации (i18n)
- [ ] Unit и Widget тесты
- [ ] CI/CD pipeline
- [ ] Обработка ошибок с Sentry
- [ ] Аналитика (Firebase Analytics)
