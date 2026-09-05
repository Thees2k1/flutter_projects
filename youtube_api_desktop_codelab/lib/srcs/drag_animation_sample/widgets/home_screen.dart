import 'package:flutter/material.dart';
import 'package:new_flutter_temp_project/srcs/drag_animation_sample/widgets/draggable_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const DraggableCard(child: FlutterLogo(size: 128)),
    );
  }
}
