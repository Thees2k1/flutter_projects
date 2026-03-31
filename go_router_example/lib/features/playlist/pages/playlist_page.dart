import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /playlist/:playlistId
/// Named: 'publicPlaylist'
///
/// Public-facing playlist page — outside the shell.
/// Distinct from /library/playlists/:playlistId (inside shell).
class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key, required this.playlistId});

  final String playlistId;

  @override
  Widget build(BuildContext context) {
    final tracks = List.generate(
      8,
      (i) => (
        'track-${playlistId.substring(playlistId.length - 2)}-${i + 1}',
        'Track ${i + 1}',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Playlist · $playlistId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF00E5FF),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Public route — outside the shell. '
                      'Compare with /library/playlists/$playlistId (inside shell).',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const RouteInfoCard(),
          const SectionHeader('Tracks'),
          ...tracks.map(
            (t) => NavTile(
              icon: Icons.music_note_rounded,
              title: t.$2,
              subtitle: '/playlist/$playlistId/track/${t.$1}',
              onTap: () => context.goNamed(
                'publicPlaylistTrack',
                pathParameters: {'playlistId': playlistId, 'trackId': t.$1},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
