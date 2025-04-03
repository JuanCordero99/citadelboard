import 'package:flutter/material.dart';
import '../model/CharacterModel.dart';

class InfoCardComponent extends StatefulWidget {
  final CharacterModel character;

  const InfoCardComponent({
    Key? key,
    required this.character,
  }) : super(key: key);

  @override
  State<InfoCardComponent> createState() => _CharacterInfoCardState();
}

class _CharacterInfoCardState extends State<InfoCardComponent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Creamos múltiples animaciones con intervalos escalonados
    _animations = List.generate(5, (index) {
      final startInterval = 0.1 + (index * 0.15);
      final endInterval = startInterval + 0.2;

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startInterval, endInterval, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    IconData _getIconByStatus() {
      if (widget.character.status == null) {
        return Icons.warning;
      }

      switch (widget.character.status.toLowerCase()) {
        case 'dead':
          return Icons.dangerous;
        case 'unknown':
          return Icons.psychology_sharp;
        case 'alive':
          return Icons.check_circle;
        default:
          return Icons.help_outline;
      }
    }

    final infoItems = [
      {'icon': Icons.person, 'label': 'Especie', 'value': widget.character.species},
      {'icon': Icons.wc, 'label': 'Género', 'value': widget.character.gender},
      {'icon': _getIconByStatus(), 'label': 'Estatus', 'value': widget.character.status},
      {'icon': Icons.location_on, 'label': 'Ubicación actual', 'value': widget.character.location},
      {'icon': Icons.map, 'label': 'Origen', 'value': widget.character.origin},
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(infoItems.length, (index) {
            return FadeTransition(
              opacity: _animations[index],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.2, 0),
                  end: Offset.zero,
                ).animate(_animations[index]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        infoItems[index]['icon'] as IconData,
                        color: Colors.blueGrey,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              infoItems[index]['label'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _capitalizeFirstLetter(infoItems[index]['value'] as String),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

}