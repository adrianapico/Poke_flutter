# Poke Flutter — [your name/version]

A Pokédex app built with Flutter that consumes the [PokeAPI](https://pokeapi.co/). Developed as part of a Flutter course, starting from a shared class base and customized with a personal theme, favorites state management, type filtering, and a redesigned detail screen.

## Features

- 🔍 Search Pokémon by name
- 🏷️ Filter by type (fire, water, grass, etc.)
- ❤️ Favorites persisted locally and synced across screens
- 📊 Detail screen with stats, abilities, height, and weight
- 🎨 Custom visual theme (color, typography, rounded corners)
- 📱 Tab navigation (Pokédex / Favorites)


## Tech stack

- Flutter / Dart
- [go_router](https://pub.dev/packages/go_router) — navigation
- [dio](https://pub.dev/packages/dio) — HTTP client
- [shared_preferences](https://pub.dev/packages/shared_preferences) — local persistence
- [PokeAPI](https://pokeapi.co/) — Pokémon data

## Getting started

```bash
git clone https://github.com/adrianapico/Poke_flutter.git
cd Poke_flutter
flutter pub get
flutter run
```

Requires the Flutter SDK ([official guide](https://docs.flutter.dev/get-started/install)) and an emulator or connected device.

## Project structure

```
lib/
├── models/       # Pokemon, PokemonDetail, PokemonStat
├── router/       # go_router configuration
├── screens/      # Home, Detail, Favorites
├── services/     # HTTP client for the PokeAPI
├── state/        # FavoritesStore (shared state)
├── theme/        # App visual theme
├── utils/        # Helper functions (text formatting)
└── widgets/      # Reusable components
```

## Credits

Based on the base project from the Flutter course at Knot Academy.