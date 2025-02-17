import 'dart:convert';

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
  String name;
  double weight;
  String size;
  
  int age;
  String imageUrl;
  String breed;
  List<Note> notes;

  Pet({
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

void main() {
  // Sample JSON data for two cats
  String jsonData = '''
  [
    {
      "name": "Whiskers",
      "weight": 4.2,
      "size": "Small",
      "age": 2,
      "imageUrl": "https://example.com/whiskers.jpg",
      "breed": "Siamese",
      "notes": [
        {
          "title": "Vet Checkup",
          "description": "Routine health check and vaccination.",
          "startDateTime": "2023-10-15T09:00:00",
          "endDateTime": "2023-10-15T10:00:00"
        },
        {
          "title": "Playtime",
          "description": "Interactive play session with feather toy.",
          "startDateTime": "2023-10-16T15:00:00",
          "endDateTime": "2023-10-16T15:30:00"
        }
      ]
    },
    {
      "name": "Mittens",
      "weight": 5.1,
      "size": "Medium",
      "age": 4,
      "imageUrl": "https://example.com/mittens.jpg",
      "breed": "Maine Coon",
      "notes": [
        {
          "title": "Grooming",
          "description": "Brushing and nail trimming session.",
          "startDateTime": "2023-10-17T11:00:00",
          "endDateTime": "2023-10-17T12:00:00"
        },
        {
          "title": "Feeding Schedule",
          "description": "Switch to new brand of cat food.",
          "startDateTime": "2023-10-18T08:00:00",
          "endDateTime": "2023-10-18T08:15:00"
        }
      ]
    }
  ]
  ''';

//------------Example ---------------------------------

  // Parse JSON data into List<Pet>
  List<dynamic> petsJson = jsonDecode(jsonData);
  // ignore: unused_local_variable
  List<Pet> pets = petsJson.map((petJson) => Pet.fromJson(petJson)).toList();
//-----------------Example end ----------------------------
  // Print pet details
//   for (var pet in pets) {
//     print('Pet Name: ${pet.name}');
//     print('Breed: ${pet.breed}');
//     print('Age: ${pet.age}');
//     print('Notes:');
//     for (var note in pet.notes) {
//       print(
//           '  - ${note.title}: ${note.description} (${note.startDateTime} to ${note.endDateTime})');
//     }
//     print('\n');
//   }
}
