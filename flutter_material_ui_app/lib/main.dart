import 'package:flutter/material.dart';
import 'package:flutter_material_ui_app/src/backdrop.dart';
import 'package:flutter_material_ui_app/color.dart';
import 'package:flutter_material_ui_app/src/models/product.dart';
import 'package:flutter_material_ui_app/src/pages/home.dart';
import 'package:flutter_material_ui_app/src/pages/login.dart';
import 'package:flutter_material_ui_app/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kShrineTheme,
      initialRoute: '/login',
      routes: {
        '/': (BuildContext context) => Backdrop(
          currentCategory: Category.all,
          frontLayer: HomePage(),
          backLayer: Container(color: Colors.transparent),
          frontTitle: Text('SHRINE'),
          backTitle: Text('MENU'),
        ),
        '/login': (context)=> LoginPage(),
      },
    );
  }
}
