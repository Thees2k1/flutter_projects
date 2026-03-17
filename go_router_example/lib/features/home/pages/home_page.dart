import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';
import '../../auth/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _featured = [
    _FeaturedItem(
      'pl-001',
      'Top Hits 2026',
      Icons.whatshot_rounded,
      Color(0xFFFF6B6B),
    ),
    _FeaturedItem(
      'pl-002',
      'Chill Mix',
      Icons.waves_rounded,
      Color(0xFF00E5FF),
    ),
    _FeaturedItem(
      'pl-003',
      'Workout Beast',
      Icons.fitness_center_rounded,
      Color(0xFFFFD60A),
    ),
    _FeaturedItem(
      'pl-004',
      'Late Night Drive',
      Icons.nightlight_rounded,
      Color(0xFF7C4DFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Melodify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Log out',
            onPressed: () async {
              await authService.logout();
              // The global redirect in router.dart automatically sends us
              // to /auth/login when isLoggedIn becomes false.
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Featured Playlists'),
          // Grid of featured playlists — each is a sub-route with a path param
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: _featured.length,
            itemBuilder: (context, i) {
              final item = _featured[i];
              return _FeaturedCard(
                item: item,
                onTap: () => context.goNamed(
                  'featuredPlaylist',
                  pathParameters: {'playlistId': item.id},
                ),
              );
            },
          ),
          const SectionHeader('Quick Navigation Demo'),
          NavTile(
            icon: Icons.search_rounded,
            title: 'Search with Query Params',
            subtitle: 'Navigates to /search?q=coldplay&genre=rock',
            onTap: () => context.go('/search?q=coldplay&genre=rock'),
          ),
          NavTile(
            icon: Icons.person_rounded,
            title: 'Artist Page (path param + extra)',
            subtitle: '/artist/artist-001 with Map extra',
            onTap: () => context.goNamed(
              'artist',
              pathParameters: {'artistId': 'artist-001'},
              extra: {'name': 'Coldplay', 'genre': 'Alternative Rock'},
            ),
          ),
          NavTile(
            icon: Icons.album_rounded,
            title: 'Album Page (path param)',
            subtitle: '/album/album-999',
            onTap: () => context.goNamed(
              'album',
              pathParameters: {'albumId': 'album-999'},
            ),
          ),
          NavTile(
            icon: Icons.play_circle_rounded,
            title: 'Open Player (slide-up transition)',
            subtitle: '/player',
            color: const Color(0xFF00E5FF),
            onTap: () => context.goNamed('player'),
          ),
          NavTile(
            icon: Icons.link_rounded,
            title: 'Deep-link: Player Track',
            subtitle: '/player/track/track-deep-001',
            color: const Color(0xFF00E5FF),
            onTap: () => context.goNamed(
              'playerTrack',
              pathParameters: {'trackId': 'track-deep-001'},
            ),
          ),
          NavTile(
            icon: Icons.error_outline_rounded,
            title: 'Go to Unknown Route (404)',
            subtitle: '/this/does/not/exist',
            color: Colors.redAccent,
            onTap: () => context.go('/this/does/not/exist'),
          ),
        ],
      ),
    );
  }
}

class _FeaturedItem {
  const _FeaturedItem(this.id, this.name, this.icon, this.color);
  final String id;
  final String name;
  final IconData icon;
  final Color color;
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item, required this.onTap});
  final _FeaturedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [item.color.withAlpha(200), item.color.withAlpha(80)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: Colors.white, size: 32),
            const Spacer(),
            Text(
              item.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'ID: ${item.id}',
              style: TextStyle(
                color: Colors.white.withAlpha(180),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
