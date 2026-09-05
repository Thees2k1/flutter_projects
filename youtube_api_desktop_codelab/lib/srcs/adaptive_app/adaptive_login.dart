import 'dart:async';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logging/logging.dart';
import 'package:new_flutter_temp_project/shared/context_extension.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import 'app_state.dart';

final _log = Logger('AdaptiveLogin');

typedef _AdaptiveLoginButtonWidgetBuilder =
    Widget Function({required VoidCallback? onPressed});

class AdaptiveLogin extends StatelessWidget {
  const AdaptiveLogin({
    super.key,
    required this.clientId,
    required this.scopes,
    required this.loginButtonChild,
  });

  final ClientId clientId;
  final List<String> scopes;
  final Widget loginButtonChild;

  @override
  Widget build(BuildContext context) {
    final platform = context.theme.platform;
    final isMobileOrWeb =
        kIsWeb ||
        platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS;

    if (isMobileOrWeb) {
      return _GoogleSignInLogin(button: _loginButton, scopes: scopes);
    } else {
      return _GoogleApisAuthLogin(
        buttonBuilder: _loginButton,
        scopes: scopes,
        clientId: clientId,
      );
    }
  }

  Widget _loginButton({required VoidCallback? onPressed}) =>
      ElevatedButton(onPressed: onPressed, child: loginButtonChild);
}

class _GoogleSignInLogin extends StatefulWidget {
  const _GoogleSignInLogin({required this.button, required this.scopes});

  final _AdaptiveLoginButtonWidgetBuilder button;
  final List<String> scopes;

  @override
  State<StatefulWidget> createState() => _GoogleSignInLoginState();
}

class _GoogleSignInLoginState extends State<_GoogleSignInLogin> {
  late final GoogleSignIn _googleSignIn;
  late final StreamSubscription _authEventsSubscription;

  @override
  void initState() {
    super.initState();

    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    _authEventsSubscription = _googleSignIn.authenticationEvents.listen(
      _onAuthenticationEventsData,
    );

    _log.fine('Attempting lightweight authentication');
    _googleSignIn.attemptLightweightAuthentication();
  }

  @override
  void dispose() {
    _authEventsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.button(
          onPressed: () {
            _googleSignIn.authenticate();
          },
        ),
      ),
    );
  }

  void _onAuthenticationEventsData(
    GoogleSignInAuthenticationEvent event,
  ) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final googleSignInClientAuthorization = await event
          .user
          .authorizationClient
          .authorizationForScopes(widget.scopes);

      if (googleSignInClientAuthorization == null) {
        _log.warning(' Google Sign-In authenticated client creation failed');
        return;
      }

      _log.fine('Google Sign-In authenticated client created');

      final context = this.context;
      if (context.mounted) {
        context.read<AuthedUserPlaylists>().authClient =
            googleSignInClientAuthorization.authClient(scopes: widget.scopes);

        context.go('/');
      }
    }
  }
}

class _GoogleApisAuthLogin extends StatefulWidget {
  const _GoogleApisAuthLogin({
    required this.buttonBuilder,
    required this.scopes,
    required this.clientId,
  });

  final _AdaptiveLoginButtonWidgetBuilder buttonBuilder;
  final List<String> scopes;
  final ClientId clientId;

  @override
  State<StatefulWidget> createState() {
    return _GoogleApisAuthLoginState();
  }
}

class _GoogleApisAuthLoginState extends State<_GoogleApisAuthLogin> {
  late final List<String> scopes;
  late final ClientId clientId;

  Uri? _authUrl;
  @override
  void initState() {
    super.initState();

    scopes = widget.scopes;
    clientId = widget.clientId;

    clientViaUserConsent(clientId, scopes, (url) {
      setState(() {
        _authUrl = Uri.parse(url);
      });
    }).then((authClient) {
      final context = this.context;
      if (context.mounted) {
        context.read<AuthedUserPlaylists>().authClient = authClient;
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authUrl != null) {
      return Scaffold(
        body: Center(
          child: Link(
            uri: _authUrl,
            builder: (context, link) => widget.buttonBuilder(onPressed: link),
          ),
        ),
      );
    }

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
