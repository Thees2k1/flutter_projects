import 'package:flutter/material.dart';

import 'views.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedViewIndex = 0;

  final List<Widget> views = [
    ArDistanceMeasurer(viewModal: ArDistanceMeasurerViewModal()),
    AREmojiWorld(),
  ];

  final List<BottomNavigationBarItem> navigationItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.calculate_outlined),
      activeIcon: Icon(Icons.calculate),
      label: "",
      tooltip: "distance measurer",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.emoji_emotions_outlined),
      activeIcon: Icon(Icons.emoji_emotions),
      label: "",
      tooltip: "emojis",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[selectedViewIndex],
      bottomNavigationBar: Builder(
        builder: (context) {
          return BottomNavigationBar(
            items: navigationItems,
            currentIndex: selectedViewIndex,
            onTap: (index) {
              setState(() {
                selectedViewIndex = index;
              });
            },
          );
        },
      ),
    );
  }
}
