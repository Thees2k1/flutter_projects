// lib/data/repositories/todo_repository_impl.dart
import 'package:clean_todolist/data/database/drift/db.dart';
import 'package:clean_todolist/domain/repository/todo_repository.dart';
import 'package:drift/drift.dart';
import '../../domain/entities/todo.dart';


class TodoRepositoryImpl implements TodoRepository {
  final AppDatabase db;

  TodoRepositoryImpl(this.db);

  @override
  Future<void> insert(Todo todo) async {
    await db.into(db.todos).insert(
          TodosCompanion.insert(title: todo.title, completed: Value(todo.completed)),
        );
  }

  @override
  Future<void> update(Todo todo) async {
    await (db.update(db.todos)..where((tbl) => tbl.id.equals(todo.id!)))
        .write(TodosCompanion(
      title: Value(todo.title),
      completed: Value(todo.completed),
    ));
  }

  @override
  Future<void> delete(int id) async {
    await (db.delete(db.todos)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Stream<List<Todo>> watchAll() {
    return db.select(db.todos).watch().map((rows) => rows
        .map((e) => Todo(id: e.id, title: e.title, completed: e.completed))
        .toList());
  }
}
