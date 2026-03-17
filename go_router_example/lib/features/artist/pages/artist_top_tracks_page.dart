import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /artist/:artistId/top-tracks
/// Named: 'artistTopTracks'
class ArtistTopTracksPage extends StatelessWidget {
  const ArtistTopTracksPage({super.key, required this.artistId});

  final String artistId;

  @override
  Widget build(BuildContext context) {
    final tracks = List.generate(
      10,
      (i) => (
        '$artistId-trk-${i + 1}',
        'Track ${i + 1}',
        '${2 + i}:${(30 + i * 7) % 60}'.padLeft(4, '0'),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Top Tracks · $artistId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Top 10'),
          ...tracks.asMap().entries.map(
            (entry) => NavTile(
              icon: Icons.music_note_rounded,
              title: '${entry.key + 1}. ${entry.value.$2}',
              subtitle: entry.value.$3,
              onTap: () => context.goNamed(
                'playerTrack',
                pathParameters: {'trackId': entry.value.$1},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
