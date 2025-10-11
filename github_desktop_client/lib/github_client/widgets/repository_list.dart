import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_desktop_client/github_client/utils/url_laucher_extension.dart';

class RepositoryList extends StatefulWidget {
  const RepositoryList({required this.gitHub, super.key});

  final GitHub gitHub;
  @override
  State<RepositoryList> createState() => _RepositoryListState();
}

class _RepositoryListState extends State<RepositoryList> {
  @override
  void initState() {
    super.initState();
    _repositories = widget.gitHub.repositories.listRepositories().toList();
  }

  late Future<List<Repository>> _repositories;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _repositories,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final repos = snapshot.data!;
        return ListView.builder(
          itemBuilder: (context, index) {
            return _RepositoryTile(
              key: ValueKey(index),
              repository: repos[index],
              onTap: () async {
                unawaited(launchUrl(repos[index].htmlUrl));
              },
            );
          },
          itemCount: repos.length,
        );
      },
    );
  }
}

class _RepositoryTile extends StatelessWidget {
  const _RepositoryTile({
    required this.repository,
    required this.onTap,
    super.key,
  });

  final Repository repository;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${repository.owner?.login ?? ''}/${repository.name}'),
      subtitle: Text(repository.description),
      onTap: onTap,
    );
  }
}
