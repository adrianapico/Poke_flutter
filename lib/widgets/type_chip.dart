import 'package:flutter/material.dart';

class TypeChip extends StatelessWidget {
  final String type;

  const TypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(type),
      backgroundColor: _colorDelTipo(type),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static Color _colorDelTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'fire':
        return Colors.red.shade300;
      case 'water':
        return Colors.blue.shade300;
      case 'grass':
        return Colors.green.shade300;
      case 'electric':
        return Colors.yellow.shade600;
      case 'ice':
        return Colors.cyan.shade200;
      case 'fighting':
        return Colors.orange.shade700;
      case 'poison':
        return Colors.purple.shade300;
      case 'ground':
        return Colors.brown.shade300;
      case 'flying':
        return Colors.indigo.shade100;
      case 'psychic':
        return Colors.pink.shade300;
      case 'bug':
        return Colors.lightGreen.shade400;
      case 'rock':
        return Colors.brown.shade400;
      case 'ghost':
        return Colors.deepPurple.shade300;
      case 'dragon':
        return Colors.indigo.shade400;
      case 'dark':
        return Colors.blueGrey.shade600;
      case 'steel':
        return Colors.blueGrey.shade300;
      case 'fairy':
        return Colors.pinkAccent.shade100;
      case 'normal':
        return Colors.grey.shade400;
      default:
        return Colors.grey.shade300;
    }
  }
}
