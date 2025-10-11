import 'package:github/github.dart';

Future<CurrentUser> getViewerDetail(String accessToken) async {
  final gitHub = GitHub(auth: Authentication.withToken(accessToken));
  return gitHub.users.getCurrentUser();
}

Future<GitHub> getGitHub(String accessToken) async {
  return GitHub(auth: Authentication.withToken(accessToken));
}
