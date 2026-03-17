import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /search/results?q=...&genre=...
/// Named: 'searchResults'
///
/// Demonstrates: sub-route that also uses query parameters.
class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key, required this.query, this.genre});

  final String query;
  final String? genre;

  @override
  Widget build(BuildContext context) {
    // Fake results for demo
    final results = List.generate(
      8,
      (i) => _ResultItem(
        artistId: 'artist-${i + 1}',
        name: '$query Artist ${i + 1}',
        genre: genre ?? 'All',
        albumId: 'album-${i + 1}',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Results: "$query"${genre != null ? " · $genre" : ""}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Results'),
          ...results.map(
            (r) => NavTile(
              icon: Icons.person_rounded,
              title: r.name,
              subtitle: 'Tap → /artist/${r.artistId}',
              onTap: () => context.goNamed(
                'artist',
                pathParameters: {'artistId': r.artistId},
                extra: {'name': r.name, 'genre': r.genre},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultItem {
  const _ResultItem({
    required this.artistId,
    required this.name,
    required this.genre,
    required this.albumId,
  });
  final String artistId;
  final String name;
  final String genre;
  final String albumId;
}
