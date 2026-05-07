import 'package:flutter/rendering.dart' show debugPrint;

import 'todo_dto.dart';

abstract class TodoService {
  Future<List<TodoDto>> getTodos();
  Future<void> saveTodos(List<TodoDto> todos);
}

class TodoServiceImpl implements TodoService {
  final List<TodoDto> _fakeDb = []; // Replace with Hive box

  @override
  Future<List<TodoDto>> getTodos() async {
    return _fakeDb;
  }

  @override
  Future<void> saveTodos(List<TodoDto> todos) async {
    _fakeDb
      ..clear()
      ..addAll(todos);

    debugPrint("updated todos: ${_fakeDb.firstOrNull?.title}");
  }
}
