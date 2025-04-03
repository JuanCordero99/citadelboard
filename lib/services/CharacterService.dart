import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/CharacterModel.dart';

class CharacterService {
  final String baseUrl = "https://rickandmortyapi.com/api/character";

  // Método para obtener la lista de personajes
  Future<List<CharacterModel>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => CharacterModel.fromJson(json)).toList();
      } else {
        throw Exception("Error al cargar los personajes");
      }
    } catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }

  //Método para obtener los detalles de ese personaje por su Id
  Future<CharacterModel> fetchCharacterById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CharacterModel.fromJson(data);
      } else {
        throw Exception("Error al cargar el personaje");
      }
    } catch (e) {
      throw Exception("Error en la solicitud");
    }
  }
}
