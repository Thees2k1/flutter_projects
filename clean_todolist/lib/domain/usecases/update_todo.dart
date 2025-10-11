
import '../entities/todo.dart';
import '../repository/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<void> call(Todo todo) => repository.update(todo);
}
