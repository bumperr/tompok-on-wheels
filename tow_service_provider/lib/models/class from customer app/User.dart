import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String imageUrl;
  String location;
  String latitude;
  String longitude; // Added location field

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl,
      required this.location,
      required this.latitude,
      required this.longitude}); // Updated constructor

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      // Updated fromJson factory
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'location': location,
      'latitude': latitude,
      'longitude': longitude // Updated toJson method
    };
  }

  LatLng get coordinates =>
      LatLng(double.parse(latitude), double.parse(longitude));
}
