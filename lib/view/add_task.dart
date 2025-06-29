import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/constants/status.dart';
import '../model/task.dart';
import '../providers/task_provider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  final Task? existing;
  const AddTaskPage({super.key, this.existing});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> statusList = [
    TaskStatus.active.value,
    TaskStatus.completed.value
  ];
  String status = TaskStatus.active.value;
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      titleController.text = widget.existing!.title;
      contentController.text = widget.existing!.content;
      status = widget.existing!.status;
      dueDate = widget.existing!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.existing == null ? 'New Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 10),
            TextField(
                controller: contentController,
                maxLines: 10,
                decoration: const InputDecoration(labelText: 'Content')),
            Row(
              children: [
                const Text('Status'),
                const Spacer(),
                DropdownButton<String>(
                  value: status,
                  onChanged: (val) => setState(() => status = val!),
                  items: statusList
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Due date'),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => dueDate = picked);
                  },
                  child: Text(dueDate != null
                      ? dueDate!.toString().split(' ')[0]
                      : 'Pick a due date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final now = DateTime.now();
                final task = Task(
                  id: widget.existing?.id,
                  title: titleController.text,
                  content: contentController.text,
                  status: status,
                  dueDate: dueDate,
                  createdAt: widget.existing?.createdAt ?? now,
                  updatedAt: now,
                );

                final notifier = ref.read(taskListProvider.notifier);
                widget.existing == null
                    ? notifier.addTask(task)
                    : notifier.updateTask(task);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ]),
        ),
      ),
    );
  }
}
