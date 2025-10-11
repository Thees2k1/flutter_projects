import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:github/github.dart';
import 'package:github_desktop_client/github_client/widgets/widgets.dart';

class GitHubSummaryView extends StatefulWidget {
  const GitHubSummaryView({
    required this.gitHub,
    super.key,
  });

  final GitHub gitHub;

  @override
  State<GitHubSummaryView> createState() => _GitHubSummaryViewState();
}

class _GitHubSummaryViewState extends State<GitHubSummaryView> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Octicons.repo),
              label: Text('Repositories'),
            ),
            NavigationRailDestination(
              icon: Icon(Octicons.issue_opened),
              label: Text('Assigned Issues'),
            ),
            NavigationRailDestination(
              icon: Icon(Octicons.git_pull_request),
              label: Text('Pull Requests'),
            ),
          ],
          labelType: NavigationRailLabelType.selected,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
        const VerticalDivider(
          thickness: 1,
          width: 1,
        ),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              RepositoryList(gitHub: widget.gitHub),
              AssignedIssuesList(gitHub: widget.gitHub),
              PullRequestsList(gitHub: widget.gitHub),
            ],
          ),
        ),
      ],
    );
  }
}
