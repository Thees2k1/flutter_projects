import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /library/playlists/:playlistId
/// Named: 'playlistDetail'
///
/// Demonstrates: path param inside the nested shell (Library tab).
/// Note: back navigation stays within the shell — the Library tab remains
/// visible in the NavigationBar.
class PlaylistDetailPage extends StatelessWidget {
  const PlaylistDetailPage({super.key, required this.playlistId});

  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlist · $playlistId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Actions'),
          NavTile(
            icon: Icons.edit_rounded,
            title: 'Edit Playlist',
            subtitle: '/library/playlists/$playlistId/edit',
            onTap: () => context.goNamed(
              'editPlaylist',
              pathParameters: {'playlistId': playlistId},
            ),
          ),
          NavTile(
            icon: Icons.play_circle_rounded,
            title: 'Play Playlist',
            subtitle: 'Push /player — shell remains below',
            color: const Color(0xFF00E5FF),
            onTap: () =>
                context.pushNamed('player', extra: {'playlistId': playlistId}),
          ),
          NavTile(
            icon: Icons.public_rounded,
            title: 'Share as Public Link',
            subtitle: '/playlist/$playlistId',
            onTap: () => context.goNamed(
              'publicPlaylist',
              pathParameters: {'playlistId': playlistId},
            ),
          ),
          // Demonstrates deep track link inside a playlist
          NavTile(
            icon: Icons.audio_file_rounded,
            title: 'Playlist Track Deep Link',
            subtitle: '/playlist/$playlistId/track/track-001',
            onTap: () => context.goNamed(
              'publicPlaylistTrack',
              pathParameters: {
                'playlistId': playlistId,
                'trackId': 'track-001',
              },
            ),
          ),
        ],
      ),
    );
  }
}
