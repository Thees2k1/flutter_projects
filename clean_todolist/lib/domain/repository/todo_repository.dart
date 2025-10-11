import '../entities/todo.dart';

abstract class TodoRepository {
  Future<void> insert(Todo todo);
  Future<void> update(Todo todo);
  Future<void> delete(int id);
  Stream<List<Todo>> watchAll();
}
