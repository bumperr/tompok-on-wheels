class Service {
  final String id;
  final String providerId;
  final String name;
  final String description;
  final String category; // 'grooming', 'veterinary', 'boarding', etc.
  final double price;
  final int duration; // in minutes
  final bool isPricePerDay; // for boarding services
  final bool isPremium; // for premium services
  final bool isActive; // whether the service is currently offered
  final String? imageUrl;
  final List<String> petTypes; // e.g., 'Cat', 'Dog', etc.
  final List<String> petSizes; // e.g., 'Small', 'Medium', 'Large'
  final int capacity; // max number of pets for this service per day

  Service({
    required this.id,
    required this.providerId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.duration,
    this.isPricePerDay = false,
    this.isPremium = false,
    this.isActive = true,
    this.imageUrl,
    this.petTypes = const ['Cat'],
    this.petSizes = const ['All'],
    this.capacity = 5,
  });

  // Create a copy with updated fields
  Service copyWith({
    String? id,
    String? providerId,
    String? name,
    String? description,
    String? category,
    double? price,
    int? duration,
    bool? isPricePerDay,
    bool? isPremium,
    bool? isActive,
    String? imageUrl,
    List<String>? petTypes,
    List<String>? petSizes,
    int? capacity,
  }) {
    return Service(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      isPricePerDay: isPricePerDay ?? this.isPricePerDay,
      isPremium: isPremium ?? this.isPremium,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      petTypes: petTypes ?? this.petTypes,
      petSizes: petSizes ?? this.petSizes,
      capacity: capacity ?? this.capacity,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'duration': duration,
      'isPricePerDay': isPricePerDay,
      'isPremium': isPremium,
      'isActive': isActive,
      'imageUrl': imageUrl,
      'petTypes': petTypes,
      'petSizes': petSizes,
      'capacity': capacity,
    };
  }

  // Create from JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      providerId: json['providerId'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      isPricePerDay: json['isPricePerDay'] ?? false,
      isPremium: json['isPremium'] ?? false,
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
      petTypes: List<String>.from(json['petTypes'] ?? ['Cat']),
      petSizes: List<String>.from(json['petSizes'] ?? ['All']),
      capacity: json['capacity'] ?? 5,
    );
  }

  // Format duration for display (e.g., "1 hr 30 min" or "45 min")
  String get formattedDuration {
    if (duration < 60) {
      return '$duration min';
    } else {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      if (minutes == 0) {
        return '$hours hr';
      } else {
        return '$hours hr $minutes min';
      }
    }
  }

  // Format price for display
  String get formattedPrice {
    return 'RM ${price.toStringAsFixed(2)}${isPricePerDay ? '/day' : ''}';
  }

  // Check if service is suitable for a particular pet
  bool isSuitableForPet(String petType, String petSize) {
    return (petTypes.contains('All') || petTypes.contains(petType)) &&
        (petSizes.contains('All') || petSizes.contains(petSize));
  }
}
