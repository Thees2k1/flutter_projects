// test/data/repository_test.dart
import 'package:clean_todolist/data/database/drift/db.dart';
import 'package:clean_todolist/data/repository/todo_repository_impl.dart';
import 'package:clean_todolist/domain/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

void main() {
  test("Insert and retrieve todo from drift", () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = TodoRepositoryImpl(db);
    await repo.insert(Todo(title: "RepoTest"));
    final todos = await repo.watchAll().first;
    expect(todos.first.title, "RepoTest");
  });
}
