import 'result.dart';
import 'todo.dart';
import 'todo_dto.dart';
import 'todo_service.dart';

abstract class TodoRepository {
  Future<Result<List<Todo>>> getTodos();
  Future<Result<void>> addTodo(String title);
  Future<Result<void>> toggleTodo(String id);
}

class TodoRepositoryImpl implements TodoRepository {
  final TodoService _service;

  TodoRepositoryImpl(this._service);

  @override
  Future<Result<List<Todo>>> getTodos() async {
    try {
      final dtos = await _service.getTodos();
      return Success(dtos.map((e) => e.toModel()).toList());
    } catch (e) {
      return Failure('Failed to fetch todos');
    }
  }

  @override
  Future<Result<void>> addTodo(String title) async {
    try {
      final current = await _service.getTodos();
      final newTodo = TodoDto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        completed: false,
      );
      await _service.saveTodos([...current, newTodo]);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to add todo');
    }
  }

  @override
  Future<Result<void>> toggleTodo(String id) async {
    try {
      final current = await _service.getTodos();
      final updated = current
          .map(
            (e) => e.id == id
                ? TodoDto(id: e.id, title: e.title, completed: !e.completed)
                : e,
          )
          .toList();
      await _service.saveTodos(updated);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to toggle todo');
    }
  }
}
