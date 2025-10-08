// lib/domain/usecases/add_todo.dart
import '../entities/todo.dart';
import '../repository/todo_repository.dart';

class AddTodo {
  final TodoRepository repository;

  AddTodo(this.repository);

  Future<void> call(Todo todo) => repository.insert(todo);
}
