import 'package:clean_todolist/domain/repository/todo_repository.dart';
import '../entities/todo.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Stream<List<Todo>> call() => repository.watchAll();
}
