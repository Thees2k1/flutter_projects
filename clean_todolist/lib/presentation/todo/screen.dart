import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'todo_view_model.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TodoViewModel>();
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Todo Clean Arch")),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Add a todo"),
            onSubmitted: (value) {
              vm.add(value);
              controller.clear();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vm.todos.length,
              itemBuilder: (_, i) {
                final todo = vm.todos[i];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (_) => vm.toggleComplete(todo),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => vm.remove(todo.id!),
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