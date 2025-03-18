// Class files for driver app data models

// lib/class/driver.dart
class Driver {
  String id;
  String name;
  String email;
  String phoneNumber;
  String imageUrl;
  String vehicleType;
  String vehicleModel;
  String licensePlate;
  String licenseNumber;
  bool isVerified;
  bool isActive;
  double rating;
  String latitude;
  String longitude;
  int completedTrips;
  double earnings;
  
  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.vehicleType,
    required this.vehicleModel,
    required this.licensePlate,
    required this.licenseNumber,
    this.isVerified = false,
    this.isActive = false,
    this.rating = 0.0,
    required this.latitude,
    required this.longitude,
    this.completedTrips = 0,
    this.earnings = 0.0,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'vehicleType': vehicleType,
      'vehicleModel': vehicleModel,
      'licensePlate': licensePlate,
      'licenseNumber': licenseNumber,
      'isVerified': isVerified,
      'isActive': isActive,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'completedTrips': completedTrips,
      'earnings': earnings,
    };
  }
  
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
      vehicleType: json['vehicleType'],
      vehicleModel: json['vehicleModel'],
      licensePlate: json['licensePlate'],
      licenseNumber: json['licenseNumber'],
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      rating: json['rating'] ?? 0.0,
      latitude: json['latitude'],
      longitude: json['longitude'],
      completedTrips: json['completedTrips'] ?? 0,
      earnings: json['earnings'] ?? 0.0,
    );
  }
}




