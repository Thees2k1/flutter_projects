import 'package:clean_todo_v2/todo.dart';

class TodoDto {
  final String id;
  final String title;
  final bool completed;

  TodoDto({required this.id, required this.title, required this.completed});

  factory TodoDto.fromModel(Todo todo) =>
      TodoDto(id: todo.id, title: todo.title, completed: todo.completed);

  Todo toModel() => Todo(id: id, title: title, completed: completed);
}
