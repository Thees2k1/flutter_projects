import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /library/artists  (inner library shell — Artists tab)
class LibraryArtistsPage extends StatelessWidget {
  const LibraryArtistsPage({super.key});

  static const _artists = [
    ('art-001', 'Coldplay', 'Alternative Rock'),
    ('art-002', 'The Weeknd', 'R&B / Pop'),
    ('art-003', 'Billie Eilish', 'Indie Pop'),
    ('art-004', 'Kendrick Lamar', 'Hip-Hop'),
    ('art-005', 'Taylor Swift', 'Pop / Country'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const RouteInfoCard(),
        const SectionHeader('Followed Artists'),
        ..._artists.map(
          (a) => NavTile(
            icon: Icons.person_rounded,
            title: a.$2,
            subtitle: '${a.$3} · ID: ${a.$1}',
            onTap: () => context.goNamed(
              'libraryArtistDetail',
              pathParameters: {'artistId': a.$1},
            ),
          ),
        ),
      ],
    );
  }
}
