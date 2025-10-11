import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment {
  dev,
  staging,
  production,
}

class GitHubOAuthConfig {
  GitHubOAuthConfig._({
    this.githubClientId = '',
    this.githubClientSecret = '',
    this.githubScopes = const [],
  });

  factory GitHubOAuthConfig.fromEnvironment() {
    final (id, secret, scope) = (
      dotenv.env['GITHUB_CLIENT_ID']!,
      dotenv.env['GITHUB_CLIENT_SECRET']!,
      ['repo', 'read:org'],
    );
    return GitHubOAuthConfig._(
      githubClientId: id,
      githubClientSecret: secret,
      githubScopes: scope,
    );
  }

  final String githubClientId;
  final String githubClientSecret;
  final List<String> githubScopes;
}
