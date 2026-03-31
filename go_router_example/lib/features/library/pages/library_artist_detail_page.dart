import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /library/artists/:artistId
/// Named: 'libraryArtistDetail'
///
/// The artist within the library shell. The bottom nav bar is still visible.
/// Demonstrates the contrast with the full-screen /artist/:artistId route.
class LibraryArtistDetailPage extends StatelessWidget {
  const LibraryArtistDetailPage({super.key, required this.artistId});

  final String artistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Artist · $artistId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF00E5FF),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This page is inside the Library shell — '
                      'the bottom nav bar remains visible. '
                      'The full-screen artist page at /artist/:id hides it.',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader('Navigate'),
          NavTile(
            icon: Icons.open_in_full_rounded,
            title: 'Full Artist Page (outside shell)',
            subtitle: '/artist/$artistId — immersive, no bottom nav',
            onTap: () => context.goNamed(
              'artist',
              pathParameters: {'artistId': artistId},
              extra: {'source': 'library'},
            ),
          ),
          NavTile(
            icon: Icons.album_rounded,
            title: 'Artist Albums (outside shell)',
            subtitle: '/artist/$artistId/albums',
            onTap: () => context.goNamed(
              'artistAlbums',
              pathParameters: {'artistId': artistId},
            ),
          ),
        ],
      ),
    );
  }
}
