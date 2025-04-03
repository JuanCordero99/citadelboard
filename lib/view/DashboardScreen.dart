import 'package:flutter/material.dart';
import '../services/CharacterService.dart';
import '../model/CharacterModel.dart';
import '../components/CardComponent.dart';
import '../components/LoadingIndicator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Dashboard> {
  final CharacterService _characterService = CharacterService();
  late Future<List<CharacterModel>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = _characterService.fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Citadel Board",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CharacterModel>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Aquí usamos el componente LoadingIndicator en lugar del CircularProgressIndicator básico
            return const LoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorView("Error al cargar los datos");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No se encontraron datos"));
          }

          final characters = snapshot.data!;

          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CardComponent(
                title: character.name,
                imageUrl: character.image,
                text1: "Status: ${character.status[0].toUpperCase() + character.status.substring(1)}",
                text2: "Species: ${character.species[0].toUpperCase() + character.species.substring(1)}",
                text3: "Gender: ${character.gender[0].toUpperCase() + character.gender.substring(1)}",
                status: character.status,
                onTap: () {
                  Navigator.pushNamed(context, 'DetailsScreen', arguments: character.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${character.name} seleccionado")),
                  );
                },
              );
            },
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
                _charactersFuture = _characterService.fetchCharacters();
              });
            },
            child: const Text('Intentar nuevamente'),
          ),
        ],
      ),
    );
  }
}