import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../state/favorites_store.dart';
import '../widgets/error_view.dart';
import '../widgets/pokemon_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _service = PokemonService();
  late Future<List<Pokemon>> _pokemonsFuture;

  @override
  void initState() {
    super.initState();
    _pokemonsFuture = _service.fetchPokemons(); // same pattern as HomeScreen
    FavoritesStore.instance.addListener(_onFavoritesChanged);
    FavoritesStore.instance.load();
  }

  @override
  void dispose() {
    FavoritesStore.instance.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() => setState(() {});

  void _retry() {
    setState(() {
      _pokemonsFuture = _service.fetchPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error, onRetry: _retry);
          }

          final favorites = snapshot.data!
              .where((p) => FavoritesStore.instance.contains(p.id))
              .toList();

          if (favorites.isEmpty) {
            return const Center(child: Text('Todavía no tienes favoritos :('));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (_, index) {
              final pokemon = favorites[index];
              return GestureDetector(
                onTap: () => context.push('/pokemon/${pokemon.id}'),
                child: PokemonCard(
                  pokemon: pokemon,
                  isFavorite: true,
                  onFavoriteTap: () =>
                      FavoritesStore.instance.toggle(pokemon.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}