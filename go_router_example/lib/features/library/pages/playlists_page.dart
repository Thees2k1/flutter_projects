import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /library/playlists  (inner library shell — Playlists tab)
class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  static const _playlists = [
    ('pl-a1', 'Morning Vibes', 12),
    ('pl-b2', 'Focus Mode', 28),
    ('pl-c3', 'Weekend BBQ', 19),
    ('pl-d4', 'Road Trip 2026', 34),
    ('pl-e5', 'Sleep Sounds', 8),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const RouteInfoCard(),
        const SectionHeader('My Playlists'),
        ..._playlists.map(
          (p) => NavTile(
            icon: Icons.queue_music_rounded,
            title: p.$2,
            subtitle: '${p.$3} tracks · ID: ${p.$1}',
            onTap: () => context.goNamed(
              'playlistDetail',
              pathParameters: {'playlistId': p.$1},
            ),
          ),
        ),
      ],
    );
  }
}
