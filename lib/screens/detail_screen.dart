import 'package:flutter/material.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_stat.dart';
import '../services/pokemon_service.dart';
import '../state/favorites_store.dart';
import '../widgets/error_view.dart';
import '../widgets/type_chip.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _service = PokemonService();
  late Future<PokemonDetail> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _service.fetchPokemonDetail(widget.id);
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
      _detailFuture = _service.fetchPokemonDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PokemonDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return SafeArea(
              child: ErrorView(error: snapshot.error, onRetry: _retry),
            );
          }

          return _DetailView(detail: snapshot.data!);
        },
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  final PokemonDetail detail;

  const _DetailView({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainColor = detail.types.isNotEmpty
        ? TypeChip.colorForType(detail.types.first)
        : theme.colorScheme.surfaceContainerHighest;
    final isFavorite = FavoritesStore.instance.contains(detail.id);

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    mainColor.withValues(alpha: 0.55),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Image.network(
                    detail.imageUrl,
                    height: 130,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.catching_pokemon, size: 120);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail.name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${detail.id.padLeft(3, '0')}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: [
                      for (final type in detail.types) TypeChip(type: type),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MeasurementChip(
                        icon: Icons.height,
                        label: '${detail.heightInMeters.toStringAsFixed(1)} m',
                        sublabel: 'Altura',
                      ),
                      _MeasurementChip(
                        icon: Icons.monitor_weight_outlined,
                        label: '${detail.weightInKg.toStringAsFixed(1)} kg',
                        sublabel: 'Peso',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('Estadísticas', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        for (final stat in detail.stats)
                          _StatRow(stat: stat, color: mainColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Habilidades', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final ability in detail.abilities)
                        Chip(label: Text(ability)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () => FavoritesStore.instance.toggle(detail.id),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MeasurementChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const _MeasurementChip({
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(sublabel, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final PokemonStat stat;
  final Color color;

  const _StatRow({required this.stat, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(stat.name)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: stat.value / 255,
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            child: Text('${stat.value}', textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}