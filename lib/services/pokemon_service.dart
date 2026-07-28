import 'package:dio/dio.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/models/pokemon_detail.dart';


class PokemonService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://pokeapi.co/api/v2',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Pokemon>> fetchPokemons({int offset = 0, int limit = 20}) async {
    final response = await _dio.get(
      '/pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final results = response.data['results'] as List;
    return results
        .map((item) => Pokemon.fromListItem(item as Map<String, dynamic>))
        .toList();
  }

  Future<PokemonDetail> fetchPokemonDetail(String id) async {
    final response = await _dio.get('/pokemon/$id');
    return PokemonDetail.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Pokemon>> fetchPokemonsByType(String type) async {
    final response = await _dio.get('/type/$type');
    final results = response.data['pokemon'] as List;
    return results
        .map(
          (item) =>
          Pokemon.fromListItem(item['pokemon'] as Map<String, dynamic>),
    )
        .toList();
  }
}
