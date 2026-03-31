import 'package:flutter/material.dart';

import 'shared/theme/theme.dart';
import 'presentation/presentation.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Let's draw",
      theme: AppTheme.lightTheme,
      home: const DrawingPage(),
    );
  }
}
