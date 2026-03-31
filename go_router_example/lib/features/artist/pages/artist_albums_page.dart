import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /artist/:artistId/albums
/// Named: 'artistAlbums'
///
/// Sub-route inheriting :artistId from the parent GoRoute.
class ArtistAlbumsPage extends StatelessWidget {
  const ArtistAlbumsPage({super.key, required this.artistId});

  final String artistId;

  @override
  Widget build(BuildContext context) {
    final albums = List.generate(
      5,
      (i) => ('$artistId-alb-${i + 1}', 'Album ${i + 1}', '${2020 + i}'),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Albums · $artistId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Discography'),
          ...albums.map(
            (a) => NavTile(
              icon: Icons.album_rounded,
              title: a.$2,
              subtitle: '${a.$3} · ID: ${a.$1} → /album/${a.$1}',
              onTap: () =>
                  context.goNamed('album', pathParameters: {'albumId': a.$1}),
            ),
          ),
        ],
      ),
    );
  }
}
