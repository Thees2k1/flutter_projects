// lib/domain/usecases/delete_todo.dart
import '../repository/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(int id) => repository.delete(id);
}
