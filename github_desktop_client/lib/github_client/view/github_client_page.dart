import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_desktop_client/github_client/utils/get_viewer_detail.dart';
import 'package:github_desktop_client/github_client/utils/github_oauth_credentials.dart';
import 'package:github_desktop_client/github_client/view/widgets/github_login.dart';
import 'package:github_desktop_client/l10n/l10n.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class GitHubClientPage extends StatelessWidget {
  const GitHubClientPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GitHubLoginWidget(
      builder: (context, client) => GitHubClientView(httpClient: client),
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }
}

class GitHubClientView extends StatelessWidget {
  const GitHubClientView({
    required this.httpClient,
    super.key,
  });

  final oauth2.Client httpClient;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.githubClientAppBarTitle)),
      body: FutureBuilder<CurrentUser>(
        future: getViewerDetail(httpClient.credentials.accessToken),
        builder: (context, snapshot) {
          return Center(
            child: snapshot.hasData
                ? Text('Hello ${snapshot.data!.login}!')
                : const Text('Retrieving viewer login details...'),
          );
        },
      ),
    );
  }
}
