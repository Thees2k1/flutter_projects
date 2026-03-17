import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /player/track/:trackId
/// Named: 'playerTrack'
///
/// Demonstrates: deep-linking directly into the player with a specific track.
/// This URL can be opened from a share link:
///   melodify://player/track/track-deep-001
///
/// The track ID is the only thing in the URL — rich metadata would be fetched
/// from an API using that ID in a real application.
class PlayerTrackPage extends StatefulWidget {
  const PlayerTrackPage({super.key, required this.trackId});

  final String trackId;

  @override
  State<PlayerTrackPage> createState() => _PlayerTrackPageState();
}

class _PlayerTrackPageState extends State<PlayerTrackPage> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track · ${widget.trackId}'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Deep-link explanation banner
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(
                    Icons.link_rounded,
                    color: Color(0xFF00E5FF),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deep Link Route',
                          style: TextStyle(
                            color: Color(0xFF00E5FF),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'This page was reached via deep-link URL. '
                          'In production, fetch track metadata using the ID below.',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const RouteInfoCard(),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              widget.trackId,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded, size: 36),
                onPressed: () {},
              ),
              const SizedBox(width: 24),
              IconButton.filled(
                iconSize: 48,
                icon: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded, size: 36),
                onPressed: () {},
              ),
            ],
          ),
          const SectionHeader('Navigate'),
          NavTile(
            icon: Icons.queue_music_rounded,
            title: 'Queue',
            subtitle: '/player/queue',
            onTap: () => context.goNamed('playerQueue'),
          ),
          NavTile(
            icon: Icons.lyrics_rounded,
            title: 'Lyrics',
            subtitle: '/player/lyrics',
            onTap: () => context.goNamed('playerLyrics'),
          ),
        ],
      ),
    );
  }
}
