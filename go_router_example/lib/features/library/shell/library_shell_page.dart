import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Inner shell for the Library branch — renders a nested tab bar
/// (Playlists | Albums | Artists) on top of the [navigationShell].
///
/// Key go_router concept:
///   A [StatefulShellRoute] nested inside a [StatefulShellBranch] creates
///   a second, independent layer of preserved navigation state. This inner
///   shell is completely contained within the Library tab of the outer shell,
///   so the bottom navigation bar from [MainShellPage] remains visible.
///
///   Synchronisation:
///   • [TabController] tracks UI state.
///   • [didUpdateWidget] keeps the controller in sync when deep-linking
///     directly to /library/albums or /library/artists.
class LibraryShellPage extends StatefulWidget {
  const LibraryShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<LibraryShellPage> createState() => _LibraryShellPageState();
}

class _LibraryShellPageState extends State<LibraryShellPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    Tab(text: 'Playlists', icon: Icon(Icons.queue_music_rounded, size: 18)),
    Tab(text: 'Albums', icon: Icon(Icons.album_rounded, size: 18)),
    Tab(text: 'Artists', icon: Icon(Icons.people_alt_rounded, size: 18)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.navigationShell.currentIndex,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(LibraryShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the TabController in sync when go_router changes the branch
    // (e.g., via deep-link or programmatic navigation).
    if (_tabController.index != widget.navigationShell.currentIndex) {
      _tabController.animateTo(widget.navigationShell.currentIndex);
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      widget.navigationShell.goBranch(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: widget.navigationShell,
    );
  }
}
