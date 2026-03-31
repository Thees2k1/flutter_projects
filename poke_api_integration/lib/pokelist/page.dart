import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pokemon_detail/page.dart';
import 'view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pokeVM = context.watch<PokeListViewModal>();
    final bodyWidget = switch (pokeVM.status) {
      PokeListStatus.initial ||
      PokeListStatus.loading => const _LoadingWidget(),
      PokeListStatus.failure => _ErrorWidget(errorMessage: pokeVM.error),
      PokeListStatus.success when pokeVM.data.isEmpty => const _EmptyWidget(),
      PokeListStatus.success => const _DataGrid(),
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          crossAxisAlignment: .center,
          children: [
            Icon(Icons.circle, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Text("Pokemon", style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
      body: Column(
        children: [
          FilterBar(margin: .symmetric(horizontal: 16)),
          SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .all(.circular(12)),
              ),
              margin: .all(8),
              child: bodyWidget,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  const FilterBar({super.key, this.margin});

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final widget = Row(
      mainAxisSize: .max,
      children: [
        Expanded(
          child: SearchBar(
            elevation: .all(0),
            constraints: BoxConstraints(
              minWidth: 360.0,
              maxWidth: 800.0,
              minHeight: 32.0,
            ),

            padding: .all(EdgeInsets.symmetric(horizontal: 12, vertical: 0)),
            leading: Icon(Icons.search, color: Colors.red, size: 16),
            hintText: "Search",
            textStyle: .all(TextStyle(fontSize: 10, height: 1.6)),
          ),
        ),
        SizedBox(width: 16),
        SortOptionsButton(),
      ],
    );

    if (margin == null) {
      return widget;
    }
    return Padding(padding: margin!, child: widget);
  }
}

enum SortOptions { alphabetical, name }

enum SortOrder { acs, dec }

class SortOptionsButton extends StatelessWidget {
  const SortOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        borderRadius: .circular(40),
        color: Colors.white,
      ),
      padding: .all(8),
      child: InkWell(onTap: () {}),
    );
  }

  void handleSortSelected(BuildContext context) {
    // context.read<PokeListViewModal>().updateSortOptions();
  }
}

// class SearchBar extends StatelessWidget {
//   const SearchBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: .circular(40),
//         color: Colors.white,
//       ),
//       padding: .all(8),
//       child: TextField(

//       ),
//     );
//   }
// }

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.errorMessage, super.key});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorMessage ?? 'Something went wrong'));
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("No data"));
  }
}

class _DataList extends StatelessWidget {
  const _DataList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PokeListViewModal>();
    final data = vm.data;
    final showFooter =
        vm.hasMore || vm.isLoadingMore || vm.loadMoreError != null;

    return ListView.builder(
      itemCount: data.length + (showFooter ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= data.length) {
          if (vm.loadMoreError != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(vm.loadMoreError!),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: vm.fetchMore,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (vm.hasMore || vm.isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              vm.fetchMore();
            });
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return const SizedBox.shrink();
        }

        if (index >= data.length - 3) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            vm.fetchMore();
          });
        }

        final item = data[index];
        return ListTile(
          key: Key('$index:${item.name}'),
          leading: item.imageUrl.isEmpty
              ? const CircleAvatar(child: Icon(Icons.catching_pokemon))
              : CircleAvatar(backgroundImage: NetworkImage(item.imageUrl)),
          title: Text(item.name),
          subtitle: Text(
            [
              item.types.map((type) => type.name).join(', '),
              '${item.stats.length} stats',
              '${item.abilities.length} abilities',
            ].join(' • '),
          ),
        );
      },
    );
  }
}

class _DataGrid extends StatelessWidget {
  const _DataGrid();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PokeListViewModal>();
    final data = vm.data;
    final showFooter =
        vm.hasMore || vm.isLoadingMore || vm.loadMoreError != null;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (index >= data.length - 6) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  vm.fetchMore();
                });
              }

              return _GridItem(
                key: Key('$index:${data[index].name}'),
                pokemon: data[index],
                onTap: () => _navigateToDetail(context, data[index]),
              );
            },
          ),
        ),
        if (showFooter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _LoadMoreFooter(vm: vm),
            ),
          ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, Pokemon pokemon) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonDetailPage(pokemon)),
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({required this.vm});

  final PokeListViewModal vm;

  @override
  Widget build(BuildContext context) {
    if (vm.loadMoreError != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(vm.loadMoreError!),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: vm.fetchMore, child: const Text('Retry')),
        ],
      );
    }

    if (vm.hasMore || vm.isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.fetchMore();
      });

      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({super.key, required this.pokemon, this.onTap});

  final Pokemon pokemon;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: .all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: Colors.black26,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: pokemon.imageUrl.isEmpty
                  ? const CircleAvatar(child: Icon(Icons.catching_pokemon))
                  : CircleAvatar(
                      backgroundImage: NetworkImage(pokemon.imageUrl),
                    ),
            ),
            SizedBox(height: 8),
            Text("#${pokemon.id}", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
