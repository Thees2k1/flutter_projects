import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_journal/src/models/entry.dart';

class EntryView extends StatefulWidget {
  const EntryView({required this.entry, super.key});
  final Entry entry;
  @override
  State<EntryView> createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                entry.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Date: ${entry.date}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const Divider(),
            Expanded(
              child: Text(
                entry.text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  height: 1.3,
                  wordSpacing: 1.2,
                  letterSpacing: 1.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
