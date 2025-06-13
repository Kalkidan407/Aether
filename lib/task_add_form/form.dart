import 'package:flutter/material.dart';

class taskFormDialog extends StatefulWidget {
  const taskFormDialog({super.key});

  @override
  State<taskFormDialog> createState() => _taskFormDialogState();
}

class _taskFormDialogState extends State<taskFormDialog> {
  final formKey = GlobalKey<FormState>;
  late final TextEditingController taskAddedController;
  late final TextEditingController taskPriority;

  void initState() {
    super.initState();
    taskAddedController = TextEditingController();
    taskPriority = TextEditingController();
  }

  @override
  void dispose() {
    taskAddedController.dispose();
    taskPriority.dispose();
  }

  void submitForm() {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a task'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: taskAddedController,
              decoration: const InputDecoration(labelText: 'Task name'),
              validator:
                  (value) =>
                      value?.isEmpty ?? true ? "Please enter a task" : null,
            ),
            TextFormField(
              controller: taskPriority,
              decoration: const InputDecoration(
                labelText: 'Add priority (A, B , or c)',
              ),
              validator:
                  (value) =>
                      value?.isEmpty ?? true ? "Please enter a task" : null,
            ),
          ],
        ),
      ),
    );
  }
}
