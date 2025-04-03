import 'package:flutter/material.dart';
import '../services/CharacterService.dart';
import '../model/CharacterModel.dart';
import '../components/ImageComponent.dart' as ImageComponent;
import '../components/InfoCardComponent.dart' as InfoCardComponent;
import '../components/LoadingIndicator.dart';

class Details extends StatefulWidget {
  final int idCharacter;

  const Details({Key? key, required this.idCharacter}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<Details> with SingleTickerProviderStateMixin {
  late Future<CharacterModel> _character;
  final CharacterService _characterService = CharacterService();
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _character = _characterService.fetchCharacterById(widget.idCharacter);

    // Configuración de la animación
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalles del Personaje",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<CharacterModel>(
        future: _character,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorView("Error al cargar los datos");
          } else if (!snapshot.hasData) {
            return _buildErrorView("No se encontraron detalles");
          }

          final character = snapshot.data!;

          return FadeTransition(
            opacity: _fadeInAnimation,
            child: Container(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Imagen del personaje con animación
                      Hero(
                        tag: 'character_${character.id}',
                        child: ImageComponent.Imagecomponent(
                          imageUrl: character.image,
                          status: character.status,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Nombre del personaje con animación
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
                          ),
                        ),
                        child: Text(
                          character.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Tarjeta de información del personaje
                      InfoCardComponent.InfoCardComponent(character: character),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _character = _characterService.fetchCharacterById(widget.idCharacter);
              });
            },
            child: const Text('Intentar nuevamente'),
          ),
        ],
      ),
    );
  }
}