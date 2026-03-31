import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /album/:albumId
/// Named: 'album'
///
/// Full-screen album page (outside the shell).
class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key, required this.albumId});

  final String albumId;

  @override
  Widget build(BuildContext context) {
    final tracks = List.generate(
      10,
      (i) => ('$albumId-trk-${i + 1}', 'Track ${i + 1}'),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Album · $albumId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Tracks'),
          // Each track is a sub-route with TWO path params: albumId + trackId
          ...tracks.map(
            (t) => NavTile(
              icon: Icons.music_note_rounded,
              title: t.$2,
              subtitle: '/album/$albumId/track/${t.$1}',
              onTap: () => context.goNamed(
                'albumTrack',
                pathParameters: {'albumId': albumId, 'trackId': t.$1},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
