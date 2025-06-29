import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/task_database.dart';
import '../model/task.dart';

enum TaskSortOption { newestFirst, oldestFirst }

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final Tasks = await TaskDatabase.getTasks();
    state = Tasks;
  }

  Future<void> addTask(Task Task) async {
    await TaskDatabase.addTask(Task);
    await loadTasks();
  }

  Future<void> updateTask(Task Task) async {
    await TaskDatabase.updateTask(Task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.deleteTask(id);
    await loadTasks();
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

final taskStatusFilterProvider = StateProvider<String?>((ref) => null);

final filteredTaskListProvider =
    Provider.family<List<Task>, String?>((ref, statusFilter) {
  final Tasks = ref.watch(taskListProvider);
  if (statusFilter == null) return Tasks;
  return Tasks.where((Task) => Task.status == statusFilter).toList();
});

final sortedTaskListProvider =
    Provider.family<List<Task>, TaskSortOption>((ref, sortOption) {
  final Tasks = ref.watch(taskListProvider);
  final sortedTasks = [...Tasks];
  sortedTasks.sort((a, b) {
    if (sortOption == TaskSortOption.newestFirst) {
      return b.createdAt.compareTo(a.createdAt);
    } else {
      return a.createdAt.compareTo(b.createdAt);
    }
  });
  return sortedTasks;
});
