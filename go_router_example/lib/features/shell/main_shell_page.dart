import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Outer shell wrapping the 4 main bottom-navigation branches:
/// Home | Search | Library | Profile
///
/// Key go_router concept:
///   [navigationShell.goBranch(index)] switches branches while preserving
///   each branch's navigation stack independently.
///   Passing [initialLocation: true] when tapping the current tab pops
///   back to the root of that branch.
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music_rounded),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab returns to that branch's root route
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
