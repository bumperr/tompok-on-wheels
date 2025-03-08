class Service {
  final String id;
  final String name;
  final String description;
  final String category; // 'grooming', 'boarding', 'veterinary'
  final double price;
  final int duration; // in minutes
  final bool isPricePerDay; // for boarding services
  final bool isPremium; // for premium services

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.duration,
    this.isPricePerDay = false,
    this.isPremium = false,
  });

  // From JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      isPricePerDay: json['isPricePerDay'] ?? false,
      isPremium: json['isPremium'] ?? false,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'duration': duration,
      'isPricePerDay': isPricePerDay,
      'isPremium': isPremium,
    };
  }
}
