import 'package:clean_todolist/domain/entities/todo.dart';
import 'package:clean_todolist/domain/repository/todo_repository.dart';
import 'package:clean_todolist/domain/usecases/add_todo.dart';
import 'package:clean_todolist/domain/usecases/get_todos.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepo implements TodoRepository {
  final List<Todo> _store = [];
  @override
  Future<void> insert(Todo todo) async => _store.add(todo.copyWith(id: _store.length));
  @override
  Future<void> update(Todo todo) async {}
  @override
  Future<void> delete(int id) async {}
  @override
  Stream<List<Todo>> watchAll() => Stream.value(_store);
}

void main() {
  test("AddTodo adds todo", () async {
    final repo = FakeRepo();
    final add = AddTodo(repo);
    await add(Todo(title: "Test"));
    final todos = await GetTodos(repo)().first;
    expect(todos.first.title, "Test");
  });
}
