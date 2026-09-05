import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_flutter_temp_project/shared/config.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/adaptive_login.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/adaptive_playlists.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/app_state.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/playlist_details.dart';
import 'package:provider/provider.dart';

class RoutePath {
  static const root = '/';
  static const playlistDetail = 'playlist/:id';
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.root,
      builder: (context, state) {
        return const AdaptivePlaylists();
      },
      redirect: (context, state) {
        bool userIsLoggedIn = context.read<AuthedUserPlaylists>().isLoggedIn;

        if (userIsLoggedIn) {
          return null;
        }

        return '/login';
      },

      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return AdaptiveLogin(
              clientId: clientId,
              scopes: scopes,
              loginButtonChild: const Text('Login to YouTube'),
            );
          },
        ),
        GoRoute(
          path: RoutePath.playlistDetail,
          builder: (context, state) {
            final title = state.uri.queryParameters['title']!;
            final id = state.pathParameters['id']!;

            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: PlaylistDetails(playlistId: id, playlistName: title),
            );
          },
        ),
      ],
    ),
  ],
);
