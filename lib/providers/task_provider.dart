import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/task_database.dart';
import '../model/task.dart';

// Manages the task list and syncs changes with the local database
class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]) {
    loadTasks();
  }

  // Loads all tasks from the database into state
  Future<void> loadTasks() async {
    try {
      final tasks = await TaskDatabase.getTasks();
      state = tasks;
    } catch (e) {
      rethrow;
    }
  }

  // Adds a new task to the database and updates state
  Future<void> addTask(Task task) async {
    try {
      await TaskDatabase.addTask(task);
      await loadTasks();
      // state = [...state, newTask];
    } catch (e) {
      rethrow;
    }
  }

  // Updates an existing task in the database and state
  Future<void> updateTask(Task updatedTask) async {
    try {
      await TaskDatabase.updateTask(updatedTask);
      state = [
        for (final task in state)
          if (task.id == updatedTask.id) updatedTask else task
      ];
    } catch (e) {
      rethrow;
    }
  }

  // Deletes a task by id from the database and updates state
  Future<void> deleteTask(int taskId) async {
    try {
      await TaskDatabase.deleteTask(taskId); // Renamed here
      state = state.where((task) => task.id != taskId).toList();
    } catch (e) {
      rethrow;
    }
  }
}

// Provides a list of tasks, supports fetching, adding, updating, deleting tasks
final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

final taskStatusFilterProvider = StateProvider<String?>((ref) => null);

final filteredTaskListProvider =
    Provider.family<List<Task>, String?>((ref, statusFilter) {
  final tasks = ref.watch(taskListProvider);
  if (statusFilter == null) return tasks;
  return tasks.where((task) => task.status == statusFilter).toList();
});

final sortedTaskListProvider =
    Provider.family<List<Task>, TaskSortOption>((ref, sortOption) {
  final tasks = ref.watch(taskListProvider);
  final sortedTasks = [...tasks];
  sortedTasks.sort((a, b) {
    switch (sortOption) {
      case TaskSortOption.createdAtAsc:
        return a.createdAt.compareTo(b.createdAt);
      case TaskSortOption.createdAtDesc:
        return b.createdAt.compareTo(a.createdAt);
      case TaskSortOption.dueDateAsc:
        return a.dueDate!.compareTo(b.dueDate!);
      case TaskSortOption.dueDateDesc:
        return b.dueDate!.compareTo(a.dueDate!);
    }
  });
  return sortedTasks;
});
