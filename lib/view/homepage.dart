import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/view/add_task.dart';

import '../constants/status.dart';
import '../providers/task_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  // Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 8, vertical: 6),
  //                         decoration: ShapeDecoration(
  //                           color: selected == 1
  //                               ? const Color(0xFF6253A8)
  //                               : const Color(0xFFE7E7E7),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(4)),
  //                         ),
  //                         child: TextWidget(
  //                           text: 'All Devotionals',
  //                           fontSize: 12,
  //                           color: selected == 1
  //                               ? Colors.white
  //                               : const Color(0xFF6D6D6D),
  //                         ),
  //                       ),

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  var tasks = ref.watch(taskListProvider);
    final filter = ref.watch(taskStatusFilterProvider);
    final tasks = ref.watch(filteredTaskListProvider(filter));

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: tasks.isEmpty
          ? const Center(
              child: Text("You don't have any task."),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE7E7E7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Text(
                          'All Tasks',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(taskStatusFilterProvider.notifier).state =
                              TaskStatus.active.value;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE7E7E7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Text(
                            'Active',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE7E7E7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Text(
                          'Completed',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(tasks[i].title),
                        subtitle: Text(tasks[i].content),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddTaskPage(existing: tasks[i])),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => ref
                              .read(taskListProvider.notifier)
                              .deleteTask(tasks[i].id!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddTaskPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
