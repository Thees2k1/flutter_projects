import 'package:flutter/material.dart';

class NavigationBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexSelect;

  const NavigationBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onIndexSelect,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'First',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          activeIcon: Icon(Icons.book),
          label: 'Second',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          activeIcon: Icon(Icons.star),
          label: 'Third',
        ),
      ],
    );
  }
}
