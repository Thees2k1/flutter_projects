import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle:true ,
        backgroundColor: Colors.transparent,elevation: 0,
        leading: Icon(Icons.menu, color: Colors.grey[900],),
        title: Text('Menu',style: TextStyle(color: Colors.grey[900]),),
      ),
    );
  }
}