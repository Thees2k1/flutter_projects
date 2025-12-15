import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_journal/src/utils/app_state.dart';
import 'package:simple_journal/src/models/entry.dart';
import 'package:simple_journal/src/widgets/entry_form.dart';
import 'package:simple_journal/src/widgets/entry_view.dart';

class LoggedInView extends StatelessWidget {
  final AppState state;
  LoggedInView({super.key, required this.state});

  final PageController _controller = PageController(initialPage: 1);

  Widget build(BuildContext context) {
    final name = state.user!.displayName ?? 'No Name';

    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Welcome back, $name!',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(),
              ),
            ),
          ),

          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<Entry>>(
                stream: state.entries,
                builder: (context, snapshot) {
                  final allEntries = snapshot.data ?? [];

                  return PageView(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    children: [
                      EntryForm(
                        key: Key('${Random().nextDouble()}'),
                        onSubmit: (e) {
                          state.writeEntryToFirebase(e);
                        },
                      ),
                      for (var entry in allEntries) EntryView(entry: entry),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
