import 'package:github_desktop_client/app/app.dart';
import 'package:github_desktop_client/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
