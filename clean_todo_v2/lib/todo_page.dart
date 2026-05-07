import 'package:clean_todo_v2/main.dart';
import 'package:clean_todo_v2/todo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart'
    show WatchingWidget, watchIt, watchValue;

class TodoPage extends WatchingWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = getIt<TodoViewModel>();
    final todos = watchValue((TodoViewModel vm) => vm.todos);
    final isLoading = watchValue((TodoViewModel vm) => vm.loadTodos.isRunning);

    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: todos
                  .map(
                    (todo) => ListTile(
                      title: Text(todo.title),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (_) => vm.toggleTodo(todo.id),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TodoTextField(
              onSubmit: (todo) => vm.addTodo(todo),
              enabled: !isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

class TodoTextField extends StatefulWidget {
  const TodoTextField({super.key, this.onSubmit, this.enabled = true});

  final ValueChanged<String>? onSubmit;

  final bool enabled;

  @override
  State<TodoTextField> createState() => _TodoTextFieldState();
}

class _TodoTextFieldState extends State<TodoTextField> {
  late final TextEditingController todoTextEditingController;

  @override
  void initState() {
    todoTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    todoTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: todoTextEditingController,
            onSubmitted: widget.enabled ? onSubmitted : null,
            decoration: const InputDecoration(labelText: 'Add Todo'),
          ),
        ),
        IconButton(
          onPressed: widget.enabled
              ? () => onSubmitted(todoTextEditingController.text)
              : null,
          icon: Icon(Icons.send_rounded, size: 16),
          iconSize: 16,
          padding: .all(8),
        ),
      ],
    );
  }

  void onSubmitted(String value) {
    widget.onSubmit?.call(value);
    todoTextEditingController.clear();
  }
}
