class Note {
  String title;
  String description;
  DateTime startDateTime;
  DateTime endDateTime;

  Note({
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
  });

  // From JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      description: json['description'],
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
    };
  }
}

class Pet {
  String id; // Added ID field
  String name;
  double weight;
  String size;

  int age;
  String imageUrl;
  String breed;
  List<Note> notes;

  Pet({
    this.id = '', // Default empty ID
    required this.name,
    required this.weight,
    required this.size,
    required this.age,
    required this.imageUrl,
    required this.breed,
    required this.notes,
  });

  // From JSON
  factory Pet.fromJson(Map<String, dynamic> json) {
    var notesFromJson = json['notes'] as List;
    List<Note> notesList =
        notesFromJson.map((note) => Note.fromJson(note)).toList();

    return Pet(
      id: json['id'] ?? '',
      name: json['name'],
      weight: json['weight'],
      size: json['size'],
      age: json['age'],
      imageUrl: json['imageUrl'],
      breed: json['breed'],
      notes: notesList,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'size': size,
      'age': age,
      'imageUrl': imageUrl,
      'breed': breed,
      'notes': notes.map((note) => note.toJson()).toList(),
    };
  }
}
