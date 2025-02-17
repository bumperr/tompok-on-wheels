class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String imageUrl;
  String location; // Added location field
  
  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl,
      required this.location}); // Updated constructor

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
      location: json['location'], // Updated fromJson factory
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'location': location, // Updated toJson method
    };
  }
}
