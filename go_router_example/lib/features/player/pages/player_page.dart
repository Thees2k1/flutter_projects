import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /player
/// Named: 'player'
///
/// Demonstrates: custom page transition (slides up from bottom, like a
/// music player sheet). Defined via [CustomTransitionPage] in router.dart.
///
/// The [extra] map carries the playback context (trackId, albumId, etc.)
/// from whatever page opened the player.
class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SizedBox(height: 24),
          // Spinning disc art
          Center(
            child: RotationTransition(
              turns: _isPlaying
                  ? _spinController
                  : const AlwaysStoppedAnimation(0),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C4DFF).withAlpha(100),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  color: Colors.white,
                  size: 72,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Controls
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
          if (extra != null) ...[
            const SectionHeader('Playback Context (from extra)'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  extra.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
                  style: const TextStyle(
                    color: Color(0xFF00E5FF),
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
          const SectionHeader('Player Sub-routes'),
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
          NavTile(
            icon: Icons.link_rounded,
            title: 'Deep-link: Specific Track',
            subtitle: '/player/track/track-deep-001',
            color: const Color(0xFF00E5FF),
            onTap: () => context.goNamed(
              'playerTrack',
              pathParameters: {'trackId': 'track-deep-001'},
            ),
          ),
        ],
      ),
    );
  }
}
