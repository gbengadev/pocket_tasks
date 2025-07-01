import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/custom%20widgets/spacing.dart';
import 'package:pocket_tasks/custom%20widgets/text.dart';
import 'package:pocket_tasks/view/add_task.dart';

import '../constants/constants.dart';
import '../constants/status.dart';
import '../model/task.dart';
import '../providers/task_provider.dart';
import '../providers/theme_providers.dart';
import '../utitlity/snackbar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedTab = 1;
  String? _filterStatus;
  TaskSortOption _sortOption = TaskSortOption.createdAtDesc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(taskStatusFilterProvider);
    final tasks = ref.watch(filteredTaskListProvider(filter));
    final themeMode = ref.watch(themeModeProvider);

    List<Task> filteredTasks = [];

    try {
      filteredTasks = _filterStatus == null
          ? tasks
          : tasks.where((t) => t.status == _filterStatus).toList();

      filteredTasks.sort((a, b) {
        switch (_sortOption) {
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
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarHelper.showError(
            context, 'Error deleting task.Please try again');
      });
    }

    ref.listen(taskStatusFilterProvider, (previous, next) {
      setState(() {
        if (next == TaskStatus.active.value) {
          _selectedTab = 2;
        } else if (next == TaskStatus.completed.value) {
          _selectedTab = 3;
        } else {
          _selectedTab = 1;
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
          title: const TextWidget(
            text: 'Tasks',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          actions: [
            Row(
              children: [
                TextWidget(
                  text: 'Dark mode',
                  color: Theme.of(context).textTheme.bodyMedium!.color!,
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              onSelected: (value) {
                setState(() {
                  if (value == 'filter_all') {
                    _filterStatus = null;
                  } else if (value.startsWith('filter_')) {
                    _filterStatus = value.replaceFirst('filter_', '');
                  } else if (value.startsWith('sort_')) {
                    _sortOption = switch (value) {
                      'sort_createdAsc' => TaskSortOption.createdAtAsc,
                      'sort_createdDesc' => TaskSortOption.createdAtDesc,
                      'sort_dueAsc' => TaskSortOption.dueDateAsc,
                      'sort_dueDesc' => TaskSortOption.dueDateDesc,
                      _ => _sortOption,
                    };
                  }
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'sort_createdAsc', child: Text('Sort by Created ↑')),
                const PopupMenuItem(
                    value: 'sort_createdDesc',
                    child: Text('Sort by Created ↓')),
                const PopupMenuItem(
                    value: 'sort_dueAsc', child: Text('Sort by Due Date ↑')),
                const PopupMenuItem(
                    value: 'sort_dueDesc', child: Text('Sort by Due Date ↓')),
              ],
            ),
          ]),
      body: (tasks.isEmpty && (_selectedTab == 1))
          ? const Center(
              child: Text("You don't have any task."),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: tasks.isEmpty
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: [
                  //Filter options("All","Active","Completed")
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectedTab = 1;
                          ref.read(taskStatusFilterProvider.notifier).state =
                              null;
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: ShapeDecoration(
                              color: _selectedTab == 1
                                  ? appThemeColour
                                  : const Color(0xFFE7E7E7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: TextWidget(
                              text: 'All',
                              color: _selectedTab == 1
                                  ? Colors.white
                                  : appThemeColour,
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectedTab = 2;

                          ref.read(taskStatusFilterProvider.notifier).state =
                              TaskStatus.active.value;
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: ShapeDecoration(
                              color: _selectedTab == 2
                                  ? appThemeColour
                                  : const Color(0xFFE7E7E7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: TextWidget(
                              text: 'Active',
                              color: _selectedTab == 2
                                  ? Colors.white
                                  : appThemeColour,
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectedTab = 3;

                          ref.read(taskStatusFilterProvider.notifier).state =
                              TaskStatus.completed.value;
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: ShapeDecoration(
                              color: _selectedTab == 3
                                  ? appThemeColour
                                  : const Color(0xFFE7E7E7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: TextWidget(
                              text: 'Completed',
                              color: _selectedTab == 3
                                  ? Colors.white
                                  : appThemeColour,
                            )),
                      ),
                    ],
                  ),
                  //Task list
                  tasks.isEmpty
                      ? const Center(
                          child: Text("You don't have any task."),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (_, i) {
                                // print(tasks.length);
                                bool isCompleted = tasks[i].status ==
                                    TaskStatus.completed.value;
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                      title: TextWidget(
                                        text: tasks[i].title,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Icon(
                                            isCompleted
                                                ? Icons.check_circle
                                                : Icons.pending,
                                            color: isCompleted
                                                ? Colors.green
                                                : Colors.orange,
                                            size: 16,
                                          ),
                                          addHorizontalSpacing(2),
                                          const TextWidget(
                                            text: 'Created on:',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          TextWidget(
                                            text:
                                                ' ${tasks[i].createdAt.toLocal().toString().split(" ")[0]}',
                                          ),
                                        ],
                                      ),
                                      onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AddTaskPage(
                                                    existing: tasks[i])),
                                          ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await ref
                                                .read(taskListProvider.notifier)
                                                .deleteTask(tasks[i].id!);
                                          } catch (e) {
                                            SnackbarHelper.showError(context,
                                                'Error deleting task.Please try again');
                                          }
                                        },
                                      )),
                                );
                              }),
                        ),
                  const SizedBox.shrink()
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
