import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /library/albums/:albumId
/// Named: 'libraryAlbumDetail'
class LibraryAlbumDetailPage extends StatelessWidget {
  const LibraryAlbumDetailPage({super.key, required this.albumId});

  final String albumId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album · $albumId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Navigate'),
          NavTile(
            icon: Icons.album_rounded,
            title: 'Full Album Page (outside shell)',
            subtitle: '/album/$albumId — no bottom nav',
            onTap: () =>
                context.goNamed('album', pathParameters: {'albumId': albumId}),
          ),
          NavTile(
            icon: Icons.audio_file_rounded,
            title: 'Jump to Track (two path params)',
            subtitle: '/album/$albumId/track/track-001',
            onTap: () => context.goNamed(
              'albumTrack',
              pathParameters: {'albumId': albumId, 'trackId': 'track-001'},
            ),
          ),
          NavTile(
            icon: Icons.play_circle_rounded,
            title: 'Play Album',
            subtitle: 'Push /player with album context',
            color: const Color(0xFF00E5FF),
            onTap: () => context.pushNamed(
              'player',
              extra: {'albumId': albumId, 'source': 'library'},
            ),
          ),
        ],
      ),
    );
  }
}
