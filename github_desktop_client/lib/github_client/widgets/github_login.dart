import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

final Uri _authorizationEndpoint = Uri.parse(
  'https://github.com/login/oauth/authorize',
);
final Uri _tokenEndpoint = Uri.parse(
  'https://github.com/login/oauth/access_token',
);
typedef AuthenticatedBuilder =
    Widget Function(
      BuildContext context,
      oauth2.Client client,
    );

class GitHubLoginWidget extends StatefulWidget {
  const GitHubLoginWidget({
    required this.builder,
    required this.githubClientId,
    required this.githubClientSecret,
    required this.githubScopes,
    super.key,
  });

  final AuthenticatedBuilder builder;
  final String githubClientId;
  final String githubClientSecret;
  final List<String> githubScopes;

  @override
  State<GitHubLoginWidget> createState() => _GitHubLoginWidgetState();
}

class _GitHubLoginWidgetState extends State<GitHubLoginWidget> {
  HttpServer? _redirectServer;
  oauth2.Client? _client;

  @override
  Widget build(BuildContext context) {
    final client = _client;
    if (client != null) {
      return widget.builder(context, client);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Login'),
        elevation: 2,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _loginToGitHub,
          child: const Text('Login to GitHub'),
        ),
      ),
    );
  }

  Future<void> _loginToGitHub() async {
    await _redirectServer?.close();
    _redirectServer = await HttpServer.bind('localhost', 0);
    final authenticatedHttpClient = await _getOAuth2Client(
      Uri.parse('http://localhost:${_redirectServer!.port}/auth'),
    );
    setState(() {
      _client = authenticatedHttpClient;
    });
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    if (widget.githubClientId.isEmpty || widget.githubClientSecret.isEmpty) {
      throw const GitHubLoginException(
        'githubCllientId and githubClientSecret must be not empty. '
        'See `lib/github_oauth_credentials.dart` for more detail.',
      );
    }

    final grant = oauth2.AuthorizationCodeGrant(
      widget.githubClientId,
      _authorizationEndpoint,
      _tokenEndpoint,
      secret: widget.githubClientSecret,
      httpClient: _JsonAcceptingHttpClient(),
    );

    final authorizationUrl = grant.getAuthorizationUrl(
      redirectUrl,
      scopes: widget.githubScopes,
    );

    await _redirect(authorizationUrl);
    final responseQueryParams = await _listen();
    final client = await grant.handleAuthorizationResponse(responseQueryParams);
    return client;
  }

  Future<void> _redirect(Uri authorizationUrl) async {
    if (await canLaunchUrl(authorizationUrl)) {
      await launchUrl(authorizationUrl);
    } else {
      throw GitHubLoginException('Could not launch $authorizationUrl');
    }
  }

  Future<Map<String, String>> _listen() async {
    final request = await _redirectServer!.first;
    final params = request.uri.queryParameters;
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await _redirectServer!.close();
    _redirectServer = null;
    return params;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}

class GitHubLoginException implements Exception {
  const GitHubLoginException(this.message);
  final String message;
  @override
  String toString() {
    return message;
  }
}
