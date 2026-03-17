import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// Demonstrates: query parameters (?q=...&genre=...)
///
/// URL: /search?q=coldplay&genre=rock
/// Named: 'search'
///
/// Query params are read from [GoRouterState.uri.queryParameters] in router.dart
/// and forwarded as constructor args — the page itself is stateless.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.query, this.genre});

  final String? query;
  final String? genre;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;

  static const _genres = [
    'All',
    'Pop',
    'Rock',
    'Hip-Hop',
    'Electronic',
    'Jazz',
    'Classical',
  ];
  String _selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query ?? '');
    _selectedGenre = widget.genre ?? 'All';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    final genre = _selectedGenre == 'All' ? null : _selectedGenre.toLowerCase();
    // Navigate to results — query params are built into the URI
    context.goNamed(
      'searchResults',
      queryParameters: {'q': q, if (genre != null) 'genre': genre},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Search'),
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Artists, songs, albums…',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send_rounded),
                onPressed: _search,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Genre chips — update query params when selected
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _genres.map((genre) {
              final selected = genre == _selectedGenre;
              return FilterChip(
                label: Text(genre),
                selected: selected,
                selectedColor: const Color(0xFF7C4DFF).withAlpha(60),
                checkmarkColor: const Color(0xFF7C4DFF),
                onSelected: (_) {
                  setState(() => _selectedGenre = genre);
                  // Re-navigate with updated query params
                  final q = _controller.text.trim();
                  if (q.isNotEmpty) {
                    context.go(
                      '/search?q=$q${genre != "All" ? "&genre=${genre.toLowerCase()}" : ""}',
                    );
                  }
                },
              );
            }).toList(),
          ),
          const SectionHeader('Demo Navigation'),
          NavTile(
            icon: Icons.search_rounded,
            title: 'Results for "coldplay"',
            subtitle: '/search/results?q=coldplay&genre=rock',
            onTap: () => context.goNamed(
              'searchResults',
              queryParameters: {'q': 'coldplay', 'genre': 'rock'},
            ),
          ),
          NavTile(
            icon: Icons.search_rounded,
            title: 'Results for "jazz" (no genre)',
            subtitle: '/search/results?q=jazz',
            onTap: () => context.goNamed(
              'searchResults',
              queryParameters: {'q': 'jazz'},
            ),
          ),
        ],
      ),
    );
  }
}
