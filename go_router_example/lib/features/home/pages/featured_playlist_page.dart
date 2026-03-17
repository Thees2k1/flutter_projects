import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// Demonstrates: single path parameter (:playlistId) as a sub-route of /home.
///
/// URL: /home/featured/:playlistId
/// Named: 'featuredPlaylist'
class FeaturedPlaylistPage extends StatelessWidget {
  const FeaturedPlaylistPage({super.key, required this.playlistId});

  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlist · $playlistId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Context'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Playlist ID read from path parameter:',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    playlistId,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00E5FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader('Navigate'),
          NavTile(
            icon: Icons.play_circle_rounded,
            title: 'Play this Playlist',
            subtitle: 'Opens /player with playlist context via extra',
            color: const Color(0xFF00E5FF),
            onTap: () => context.goNamed(
              'player',
              extra: {'playlistId': playlistId, 'source': 'featured'},
            ),
          ),
          NavTile(
            icon: Icons.public_rounded,
            title: 'View as Public Playlist',
            subtitle: '/playlist/$playlistId',
            onTap: () => context.goNamed(
              'publicPlaylist',
              pathParameters: {'playlistId': playlistId},
            ),
          ),
          NavTile(
            icon: Icons.arrow_back_rounded,
            title: 'Back to Home',
            subtitle: 'context.pop()',
            color: Colors.grey,
            onTap: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
