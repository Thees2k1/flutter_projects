import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:new_flutter_temp_project/shared/context_extension.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/playlist_details.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/playlists.dart';
import 'package:split_view/split_view.dart';

class AdaptivePlaylists extends StatelessWidget {
  const AdaptivePlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetPlatform = context.theme.platform;

    final isMobile =
        targetPlatform == TargetPlatform.android ||
        targetPlatform == TargetPlatform.iOS;

    if (isMobile || screenWidth <= 600) {
      return const _NarrowDisplayPlaylists(
        key: ValueKey("narrow_display_playlists"),
      );
    }

    return const _WideDisplayPlaylists(key: ValueKey("wide_display_playlists"));
  }
}

class _NarrowDisplayPlaylists extends StatelessWidget {
  const _NarrowDisplayPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlutterDev Playlists')),
      body: Playlists(
        onPlaylistSelected: (playlist) {
          context.go(
            Uri(
              path: '/playlist/${playlist.id}',
              queryParameters: <String, String>{
                'title': playlist.snippet!.title!,
              },
            ).toString(),
          );
        },
      ),
    );
  }
}

class _WideDisplayPlaylists extends StatefulWidget {
  const _WideDisplayPlaylists({super.key});

  @override
  State<_WideDisplayPlaylists> createState() => _WideDisplayPlaylistsState();
}

class _WideDisplayPlaylistsState extends State<_WideDisplayPlaylists> {
  Playlist? selectedPlaylist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: switch (selectedPlaylist?.snippet?.title) {
          String title => Text('FlutterDev Playlist: $title'),
          _ => const Text('FlutterDev Playlists'),
        },
      ),
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        children: [
          Playlists(
            onPlaylistSelected: (playlist) {
              setState(() {
                selectedPlaylist = playlist;
              });
            },
          ),
          switch ((selectedPlaylist?.id, selectedPlaylist?.snippet?.title)) {
            (String id, String title) => PlaylistDetails(
              playlistId: id,
              playlistName: title,
            ),
            _ => const Center(child: Text('Select a playlist')),
          },
        ],
      ),
    );
  }
}
