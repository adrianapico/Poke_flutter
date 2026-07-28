import 'pokemon_stat.dart';

class PokemonDetail {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  final List<PokemonStat> stats;
  final double heightInMeters;
  final double weightInKg;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.heightInMeters,
    required this.weightInKg,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'] as String;
    return PokemonDetail(
      id: (json['id'] as int).toString(),
      name: rawName[0].toUpperCase() + rawName.substring(1),
      imageUrl:
      json['sprites']['other']['official-artwork']['front_default']
      as String? ??
          '', // can come back null — the errorBuilder placeholder covers this
      types: (json['types'] as List)
          .map((item) => item['type']['name'] as String)
          .toList(),
      abilities: (json['abilities'] as List)
          .map((item) => item['ability']['name'] as String)
          .toList(),
      stats: (json['stats'] as List)
          .map((item) => PokemonStat.fromJson(item as Map<String, dynamic>))
          .toList(),
      // PokeAPI returns height in decimetres and weight in hectograms;
      // convert to metres/kilograms, which is what people expect to read.
      heightInMeters: (json['height'] as int) / 10,
      weightInKg: (json['weight'] as int) / 10,
    );
  }
}