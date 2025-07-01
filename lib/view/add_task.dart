import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/constants/status.dart';
import 'package:pocket_tasks/custom%20widgets/spacing.dart';
import 'package:pocket_tasks/utitlity/snackbar.dart';
import '../custom widgets/text.dart';
import '../model/task.dart';
import '../providers/task_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
          title: TextWidget(
        text: widget.existing == null ? 'New Task' : 'Edit Task',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                  key: const Key('taskTitleField'),
                  controller: titleController,
                  maxLength: 20,
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelAlignment: FloatingLabelAlignment.start)),
              const SizedBox(height: 10),
              TextField(
                  key: const Key('taskContentField'),
                  controller: contentController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                      labelText: 'Content',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelAlignment: FloatingLabelAlignment.start)),
              addVerticalSpacing(20),
              Row(
                children: [
                  const TextWidget(
                    text: 'Status',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  const Spacer(),
                  DropdownButton2(
                    value: status,
                    onChanged: (val) => setState(() => status = val as String),
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium!.color!,
                    ),
                    items: statusList
                        .map((s) =>
                            DropdownMenuItem<String>(value: s, child: Text(s)))
                        .toList(),
                  )
                ],
              ),
              Row(
                children: [
                  const TextWidget(
                    text: 'Due date',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
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
                    child: TextWidget(
                        text: dueDate != null
                            ? dueDate!.toString().split(' ')[0]
                            : 'Pick a due date'),
                  ),
                ],
              ),
              addVerticalSpacing(30),
              FilledButton(
                  key: const Key('submitTaskButton'),
                  onPressed: _addTask,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide.none,
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const TextWidget(
                    text: 'Save',
                    color: Colors.white,
                    fontSize: 14,
                  )),
            ]),
          ),
        ),
      ),
    );
  }

//Helper method to validate text fields and create a task
  void _addTask() {
    {
      if (titleController.text.isEmpty) {
        SnackbarHelper.showError(context, 'Please enter a name for this task.');
        return;
      }
      if (dueDate == null) {
        SnackbarHelper.showError(
            context, 'Please select a due date for this task.');
        return;
      }
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

      SnackbarHelper.showSuccess(
          context,
          widget.existing == null
              ? "Task created successfully!"
              : "Task updated successfully!");
      Navigator.pop(context);
    }
  }
}
