import 'package:clean_todo_v2/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

import 'todo_repository.dart';
import 'todo_service.dart';
import 'todo_view_model.dart';

void main() {
  setupTodoModule();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: TodoPage()));
  }
}

final getIt = GetIt.instance;

void setupTodoModule() {
  getIt.registerLazySingleton<TodoService>(() => TodoServiceImpl());
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => TodoViewModel(getIt()));
}
