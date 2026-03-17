import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /artist/:artistId
/// Named: 'artist'
///
/// Full-screen artist page — outside the shell, so no bottom nav bar.
///
/// Demonstrates:
///  • Single path parameter (:artistId)
///  • Extra data (Map) passed alongside the URL (not encoded in it)
///  • Two sub-routes sharing the same parent path param
class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key, required this.artistId, this.extra});

  final String artistId;

  /// Rich object passed via context.goNamed('artist', extra: {...}).
  /// Only available during the current session; not present on cold deep-links.
  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    final name = extra?['name'] as String? ?? 'Unknown Artist';
    final genre = extra?['genre'] as String? ?? '—';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero banner
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7C4DFF).withAlpha(200),
                  const Color(0xFF00E5FF).withAlpha(100),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    genre,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const RouteInfoCard(),
          const SectionHeader('Sub-routes'),
          NavTile(
            icon: Icons.album_rounded,
            title: "Artist's Albums",
            subtitle: '/artist/$artistId/albums',
            onTap: () => context.goNamed(
              'artistAlbums',
              pathParameters: {'artistId': artistId},
            ),
          ),
          NavTile(
            icon: Icons.music_note_rounded,
            title: 'Top Tracks',
            subtitle: '/artist/$artistId/top-tracks',
            onTap: () => context.goNamed(
              'artistTopTracks',
              pathParameters: {'artistId': artistId},
            ),
          ),
          const SectionHeader('Related'),
          NavTile(
            icon: Icons.play_circle_rounded,
            title: 'Play Artist Radio',
            subtitle: 'Opens player with artist context',
            color: const Color(0xFF00E5FF),
            onTap: () => context.goNamed(
              'player',
              extra: {'artistId': artistId, 'mode': 'radio'},
            ),
          ),
        ],
      ),
    );
  }
}
