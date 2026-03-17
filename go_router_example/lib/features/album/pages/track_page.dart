import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL (from album):    /album/:albumId/track/:trackId
/// URL (from playlist): /playlist/:playlistId/track/:trackId
///
/// Named: 'albumTrack' | 'publicPlaylistTrack'
///
/// Demonstrates: the same page class handling two different routes.
/// The source context (album vs playlist) is determined by which
/// constructor params are non-null.
class TrackPage extends StatelessWidget {
  const TrackPage({
    super.key,
    this.albumId,
    this.playlistId,
    required this.trackId,
  }) : assert(albumId != null || playlistId != null);

  final String? albumId;
  final String? playlistId;
  final String trackId;

  String get _context =>
      albumId != null ? 'From album: $albumId' : 'From playlist: $playlistId';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track · $trackId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resolved context',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _context,
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader('Play'),
          NavTile(
            icon: Icons.play_circle_rounded,
            title: 'Open in Player',
            subtitle: 'Push /player with track context',
            color: const Color(0xFF00E5FF),
            onTap: () => context.pushNamed(
              'player',
              extra: {
                'trackId': trackId,
                if (albumId != null) 'albumId': albumId,
                if (playlistId != null) 'playlistId': playlistId,
              },
            ),
          ),
          NavTile(
            icon: Icons.link_rounded,
            title: 'Player Deep-link URL',
            subtitle: '/player/track/$trackId',
            color: const Color(0xFF7C4DFF),
            onTap: () => context.goNamed(
              'playerTrack',
              pathParameters: {'trackId': trackId},
            ),
          ),
        ],
      ),
    );
  }
}
