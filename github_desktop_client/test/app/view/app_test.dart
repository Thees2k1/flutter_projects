// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:github_desktop_client/app/app.dart';
import 'package:github_desktop_client/github_client/view/github_client_page.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(GitHubClientPage), findsOneWidget);
    });
  });
}
