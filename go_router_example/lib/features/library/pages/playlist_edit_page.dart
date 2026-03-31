import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /library/playlists/:playlistId/edit
/// Named: 'editPlaylist'
///
/// Demonstrates: 3-level deep sub-route still inside the nested shell.
/// Path param (:playlistId) flows down from the parent route.
class PlaylistEditPage extends StatelessWidget {
  const PlaylistEditPage({super.key, required this.playlistId});

  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit · $playlistId'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Saved!')));
              context.pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Edit Fields'),
          TextFormField(
            initialValue: 'My Playlist',
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: 'A great collection',
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
