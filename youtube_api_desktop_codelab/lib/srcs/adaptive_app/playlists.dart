import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/adaptive_image.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/adaptive_text.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

typedef PlaylistSelectedCallback = void Function(Playlist playlist);

class Playlists extends StatelessWidget {
  const Playlists({super.key, this.onPlaylistSelected});

  final PlaylistSelectedCallback? onPlaylistSelected;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthedUserPlaylists>(
      builder: (context, authedUser, child) {
        final playlists = authedUser.playlists;
        if (playlists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _PlaylistsListView(
          items: playlists,
          onPlaylistSelected: onPlaylistSelected,
        );
      },
    );
  }
}

class _PlaylistsListView extends StatefulWidget {
  const _PlaylistsListView({required this.items, this.onPlaylistSelected});

  final List<Playlist> items;
  final PlaylistSelectedCallback? onPlaylistSelected;

  @override
  State<_PlaylistsListView> createState() => _PlaylistsListViewState();
}

class _PlaylistsListViewState extends State<_PlaylistsListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          var playlist = widget.items[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: AdaptiveImage(
                playlist.snippet!.thumbnails!.default_!.url!,
              ),
              title: AdaptiveText(playlist.snippet!.title!),
              subtitle: AdaptiveText(playlist.snippet!.description!),
              onTap: () => widget.onPlaylistSelected?.call(playlist),
            ),
          );
        },
      ),
    );
  }
}
