class CharacterModel {
  // Atributos del objeto
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String origin;
  final String location;
  final String image;

  // Constructor del objeto
  CharacterModel(this.id, this.name, this.status, this.species,
                this.type, this.gender,this.origin, this.location, this.image);

  // Extracción de datos del API
  CharacterModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        status = json['status'] as String,
        species = json['species'] as String,
        type = json['type'] as String? ?? 'Unknown',
        gender = json['gender'] as String,
        origin = json['origin']['name'] as String,
        location = json['location']['name'] as String,
        image = json['image'] as String;

  // Método para convertir a JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'type': type,
    'gender': gender,
    'origin': origin,
    'location': location,
    'image': image,
  };
}
