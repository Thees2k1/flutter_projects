import 'package:flutter/widgets.dart';
import 'package:flutter_it/flutter_it.dart';

import 'result.dart';
import 'todo.dart';
import 'todo_repository.dart';

class TodoViewModel {
  final TodoRepository _repo;

  ValueNotifier<List<Todo>> todos = ValueNotifier([]);

  late final loadTodos = Command.createAsyncNoParam(initialValue: [], () async {
    final result = await _repo.getTodos();

    switch (result) {
      case Success(data: final data):
        todos.value = data;
      case Failure(message: final msg):
        throw Exception(msg);
    }
  });

  late final addTodo = Command.createAsyncNoResult<String>((title) async {
    final result = await _repo.addTodo(title);

    switch (result) {
      case Success():
        await loadTodos.runAsync();
      case Failure(message: final msg):
        throw Exception(msg);
    }
  });

  late final toggleTodo = Command.createAsyncNoResult<String>((id) async {
    final result = await _repo.toggleTodo(id);

    switch (result) {
      case Success():
        await loadTodos.runAsync();
      case Failure(message: final msg):
        throw Exception(msg);
    }
  });

  TodoViewModel(this._repo);
}
