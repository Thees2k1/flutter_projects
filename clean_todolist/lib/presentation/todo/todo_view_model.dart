// lib/presentation/todo_view_model.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/update_todo.dart';
import '../../domain/usecases/delete_todo.dart';

class TodoViewModel extends ChangeNotifier {
  final AddTodo addTodo;
  final GetTodos getTodos;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  TodoViewModel({
    required this.addTodo,
    required this.getTodos,
    required this.updateTodo,
    required this.deleteTodo,
  }) {
    _observeTodos();
  }

  void _observeTodos() {
    getTodos().listen((list) {
      _todos = list;
      notifyListeners();
    });
  }

  Future<void> add(String title) async {
    await addTodo(Todo(title: title));
  }

  Future<void> toggleComplete(Todo todo) async {
    await updateTodo(todo.copyWith(completed: !todo.completed));
  }

  Future<void> remove(int id) async {
    await deleteTodo(id);
  }
}
