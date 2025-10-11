import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_desktop_client/github_client/cubit/github_client_cubit.dart';
import 'package:github_desktop_client/l10n/l10n.dart';

class GitHubClientPage extends StatelessWidget {
  const GitHubClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GitHubClientCubit(),
      child: const GitHubClientView(),
    );
  }
}

class GitHubClientView extends StatelessWidget {
  const GitHubClientView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.githubClientAppBarTitle)),
      body: const Center(child: GitHubClientText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<GitHubClientCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<GitHubClientCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class GitHubClientText extends StatelessWidget {
  const GitHubClientText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((GitHubClientCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
