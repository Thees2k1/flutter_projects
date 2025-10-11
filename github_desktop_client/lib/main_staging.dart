import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_desktop_client/app/app.dart';
import 'package:github_desktop_client/bootstrap.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env.staging');
  await bootstrap(() => const App());
}
