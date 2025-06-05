import 'package:flutter/material.dart';

class Task {
  String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

class TaskList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<Task> tasks = [];
  final TextEditingController _controller = TextEditingController();

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title));
      _controller.clear();
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do-List')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(13.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Add a task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      addTask(_controller.text.trim());
                    }
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                final task = tasks[index];

                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) => toggleTask(index),
                  ),
                  trailing: IconButton(
                    onPressed: () => deleteTask(index),
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
