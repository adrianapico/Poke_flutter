import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../state/favorites_store.dart';
import '../widgets/error_view.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = PokemonService();
  late Future<List<Pokemon>> _pokemonsFuture;
  List<Pokemon> _pokemons = []; // accumulated across pages
  bool _isLoadingMore = false;

  String _searchQuery = '';
  String? _searchError; // null = no error

  @override
  void initState() {
    super.initState();
    _pokemonsFuture = _loadFirstPage(); // fired ONCE, not per build
    FavoritesStore.instance.addListener(_onFavoritesChanged);
    FavoritesStore.instance.load();
  }

  @override
  void dispose() {
    FavoritesStore.instance.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() => setState(() {});

  Future<List<Pokemon>> _loadFirstPage() async {
    final pokemons = await _service.fetchPokemons();
    _pokemons = pokemons; // no setState: FutureBuilder rebuilds on completion
    return pokemons;
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    try {
      final more = await _service.fetchPokemons(offset: _pokemons.length);
      setState(() => _pokemons = [..._pokemons, ...more]);
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(e))));
      }
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _searchError = value.contains(RegExp(r'[0-9]'))
          ? 'El nombre solo lleva letras'
          : null;
    });
  }

  void _retry() {
    setState(() {
      _pokemonsFuture = _loadFirstPage(); // a brand new Future
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error, onRetry: _retry);
          }

          return _buildContent(_pokemons);
        },
      ),
    );
  }

  Widget _buildContent(List<Pokemon> pokemons) {
    final filtered = pokemons
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Busca un Pokémon...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              errorText: _searchError,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Ningún Pokémon coincide'))
              : CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid.builder(
                  itemCount: filtered.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (_, index) {
                    final pokemon = filtered[index];
                    return GestureDetector(
                      onTap: () => context.push('/pokemon/${pokemon.id}'),
                      child: PokemonCard(
                        pokemon: pokemon,
                        isFavorite:
                        FavoritesStore.instance.contains(pokemon.id),
                        onFavoriteTap: () =>
                            FavoritesStore.instance.toggle(pokemon.id),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isLoadingMore ? null : _loadMore,
                      child: _isLoadingMore
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Text('Cargar más'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}