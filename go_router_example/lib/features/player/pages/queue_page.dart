import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /player/queue
/// Named: 'playerQueue'
class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final queue = List.generate(
      12,
      (i) => ('track-q-${i + 1}', 'Queued Track ${i + 1}'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Up Next'),
        leading: BackButton(onPressed: () => context.goNamed('player')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Queue'),
          ...queue.map(
            (t) => NavTile(
              icon: Icons.drag_indicator_rounded,
              title: t.$2,
              subtitle: 'Tap → /player/track/${t.$1}',
              onTap: () => context.goNamed(
                'playerTrack',
                pathParameters: {'trackId': t.$1},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
