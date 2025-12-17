import 'package:flutter/material.dart';
import 'package:flutter_nextgen_ui/styles.dart';

class AppTheme {
  static final defaulAppTheme = ThemeData().copyWith();
  static final defaulAppDarkTheme = ThemeData(brightness: Brightness.dark);
}

class NextGenApp extends StatelessWidget {
  const NextGenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.defaulAppDarkTheme,
      home: Scaffold(
        body: Center(
          child: Text(
            'Insert Next-Generation UI Here...',
            style: TextStyles.h2,
          ),
        ),
      ),
    );
  }
}
