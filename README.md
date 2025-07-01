#  Pocket Tasks

A minimalist task management app built with **Flutter**, **Riverpod**, and **SQLite**.  
Features include task creation, local storage, sorting, filtering, and light/dark mode toggle.

---

## 🚀 Getting Started

### Requirements

- Flutter 3.10+
- Dart 3.x
- Android Studio or VS Code

### Steps

```bash
git clone https://github.com/gbengadev/pocket.git
cd flutter-task-manager
flutter pub get
flutter run

#  State Management in Flutter Task Manager

This app uses **Riverpod** for state management — a robust, testable, and safe alternative to Provider. Riverpod allows global and scoped state sharing, dependency injection, and reactive UI updates without relying on `BuildContext`.

---

##  Why Riverpod?

-  Compile-time safety
-  Stateless and testable
-  No `context.watch()` or `context.read()`
-  Great integration with async logic and business layers

---

##  Core Riverpod Concepts in Use

| Concept                     | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `StateNotifier`             | Manages mutable state like task lists                                       |
| `StateNotifierProvider`     | Exposes a `StateNotifier` instance to the widget tree                       |
| `StateProvider`             | Holds simple values like filters and theme toggles                          |
| `ProviderScope`             | Top-level widget that provides Riverpod state access to the whole app       |
| `ref.watch()` / `ref.read()`| Reactively listens to providers or reads without rebuilds                   |

---

##  How State Is Structured

### 1. **Task State Management**

- `TaskListNotifier` extends `StateNotifier<List<Task>>`
- Exposes methods: `addTask`, `updateTask`, `deleteTask`, `loadTasks`
- Keeps the task list reactive and synced with SQLite

```dart
final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

#  App Architecture - Flutter Task Manager

The app is structured using **feature-first modular architecture** with **Riverpod** for state management and **SQLite** for persistent storage. It cleanly separates concerns across models, services, providers, UI, and utilities.

---

## 🔁 High-Level Layers

| Layer       | Description                                                                         |
|-------------|-------------------------------------------------------------------------------------|
| `models/`        | Defines app data structures and enums (e.g., `Task`, `TaskSortOption`)              |
| `services/`      | Encapsulates local persistence logic (e.g., SQLite through `TaskDatabase`)          |
| `providers/`     | Manages state using Riverpod, separate from UI                                      |
| `pages/`         | UI layer — receives state from providers and reacts to changes                      |
| `utils/`         | Contains helper classes like snackbar utilities                                     |
| `custom-widgtes/`| Contains reusable widgets which can be used any where in the app               |

---


