import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/route_info_card.dart';

/// URL: /player/lyrics
/// Named: 'playerLyrics'
class LyricsPage extends StatelessWidget {
  const LyricsPage({super.key});

  static const _lyrics = [
    'Look at the stars,',
    'Look how they shine for you,',
    'And everything you do,',
    'Yeah they were all yellow.',
    '',
    'I came along,',
    'I wrote a song for you,',
    'And all the things you do,',
    'And it was called "Yellow".',
    '',
    'So then I took my turn,',
    'Oh what a thing to have done,',
    'And it was all yellow.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lyrics'),
        leading: BackButton(onPressed: () => context.goNamed('player')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const RouteInfoCard(),
          const SectionHeader('Lyrics'),
          ..._lyrics.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                line,
                style: TextStyle(
                  color: line.isEmpty ? Colors.transparent : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
