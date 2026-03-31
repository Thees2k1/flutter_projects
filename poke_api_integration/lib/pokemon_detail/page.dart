import 'package:flutter/material.dart';

import '../core/models/pokemon.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage(this.pokemon, {super.key});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _FancyBackground()),
          ListView(
            children: [
              Row(
                mainAxisAlignment: .center,
                children: [
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: pokemon.imageUrl.isEmpty
                        ? const CircleAvatar(
                            child: Icon(Icons.catching_pokemon),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(pokemon.imageUrl),
                          ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: .center,
                children: [
                  const Icon(Icons.catching_pokemon),
                  Text("#${pokemon.id} ${pokemon.name}"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FancyBackground extends StatelessWidget {
  const _FancyBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.black38, Colors.redAccent]),
      ),
    );
  }
}
