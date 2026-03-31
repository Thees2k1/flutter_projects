import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /library/albums  (inner library shell — Albums tab)
class LibraryAlbumsPage extends StatelessWidget {
  const LibraryAlbumsPage({super.key});

  static const _albums = [
    ('alb-001', 'Music of the Spheres', 'Coldplay'),
    ('alb-002', 'After Hours', 'The Weeknd'),
    ('alb-003', '30', 'Adele'),
    ('alb-004', 'Sour', 'Olivia Rodrigo'),
    ('alb-005', 'Fine Line', 'Harry Styles'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const RouteInfoCard(),
        const SectionHeader('Saved Albums'),
        ..._albums.map(
          (a) => NavTile(
            icon: Icons.album_rounded,
            title: a.$2,
            subtitle: '${a.$3} · ID: ${a.$1}',
            onTap: () => context.goNamed(
              'libraryAlbumDetail',
              pathParameters: {'albumId': a.$1},
            ),
          ),
        ),
      ],
    );
  }
}
