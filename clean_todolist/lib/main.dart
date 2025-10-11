import 'package:clean_todolist/data/database/drift/db.dart';
import 'package:clean_todolist/data/repository/todo_repository_impl.dart';
import 'package:clean_todolist/domain/usecases/add_todo.dart';
import 'package:clean_todolist/domain/usecases/delete_todo.dart';
import 'package:clean_todolist/domain/usecases/get_todos.dart';
import 'package:clean_todolist/domain/usecases/update_todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/todo/screen.dart';
import 'presentation/todo/todo_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final todoRepo = TodoRepositoryImpl(db);

  runApp(ChangeNotifierProvider(create: (_) => TodoViewModel(
    getTodos: GetTodos(todoRepo),
    addTodo: AddTodo(todoRepo),
    updateTodo: UpdateTodo(todoRepo),
    deleteTodo: DeleteTodo(todoRepo),
  ), child: const MainApp()));
}

class MainApp extends StatelessWidget {

  
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoPage(),
    );  
  }
}
