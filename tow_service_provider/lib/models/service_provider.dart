class BusinessHours {
  final int day; // 1-7 (Monday-Sunday)
  final String? openTime; // Format: "09:00"
  final String? closeTime; // Format: "17:00"
  final bool isOpen;

  BusinessHours({
    required this.day,
    this.openTime,
    this.closeTime,
    this.isOpen = true,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'openTime': openTime,
      'closeTime': closeTime,
      'isOpen': isOpen,
    };
  }

  // Create from JSON
  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    return BusinessHours(
      day: json['day'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      isOpen: json['isOpen'] ?? true,
    );
  }

  // Get day name
  String get dayName {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  // Format hours for display
  String get displayHours {
    if (!isOpen) return 'Closed';
    if (openTime == null || closeTime == null) return 'Not Set';
    return '$openTime - $closeTime';
  }
}

class ServiceProvider {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String category; // "Grooming", "Veterinary", "Boarding", etc.
  final String description;
  final String logoUrl;
  final bool isVerified;
  final List<BusinessHours> businessHours;
  final String latitude;
  final String longitude;
  final double rating;
  final int reviewCount;
  final bool acceptsBookings;

  // Additional business details
  final String? website;
  final String? taxId;
  final String? registrationNumber;
  final List<String> amenities;
  final List<String> paymentMethods;
  final int capacityPerDay;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.category,
    required this.description,
    required this.logoUrl,
    this.isVerified = false,
    required this.businessHours,
    required this.latitude,
    required this.longitude,
    this.rating = 0,
    this.reviewCount = 0,
    this.acceptsBookings = true,
    this.website,
    this.taxId,
    this.registrationNumber,
    this.amenities = const [],
    this.paymentMethods = const [],
    this.capacityPerDay = 10,
  });

  // Copy with method
  ServiceProvider copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? category,
    String? description,
    String? logoUrl,
    bool? isVerified,
    List<BusinessHours>? businessHours,
    String? latitude,
    String? longitude,
    double? rating,
    int? reviewCount,
    bool? acceptsBookings,
    String? website,
    String? taxId,
    String? registrationNumber,
    List<String>? amenities,
    List<String>? paymentMethods,
    int? capacityPerDay,
  }) {
    return ServiceProvider(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      category: category ?? this.category,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      isVerified: isVerified ?? this.isVerified,
      businessHours: businessHours ?? this.businessHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      acceptsBookings: acceptsBookings ?? this.acceptsBookings,
      website: website ?? this.website,
      taxId: taxId ?? this.taxId,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      amenities: amenities ?? this.amenities,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      capacityPerDay: capacityPerDay ?? this.capacityPerDay,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'category': category,
      'description': description,
      'logoUrl': logoUrl,
      'isVerified': isVerified,
      'businessHours': businessHours.map((hour) => hour.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviewCount': reviewCount,
      'acceptsBookings': acceptsBookings,
      'website': website,
      'taxId': taxId,
      'registrationNumber': registrationNumber,
      'amenities': amenities,
      'paymentMethods': paymentMethods,
      'capacityPerDay': capacityPerDay,
    };
  }

  // Create from JSON
  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      category: json['category'],
      description: json['description'],
      logoUrl: json['logoUrl'],
      isVerified: json['isVerified'] ?? false,
      businessHours: (json['businessHours'] as List)
          .map((hour) => BusinessHours.fromJson(hour))
          .toList(),
      latitude: json['latitude'],
      longitude: json['longitude'],
      rating: json['rating'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      acceptsBookings: json['acceptsBookings'] ?? true,
      website: json['website'],
      taxId: json['taxId'],
      registrationNumber: json['registrationNumber'],
      amenities: List<String>.from(json['amenities'] ?? []),
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
      capacityPerDay: json['capacityPerDay'] ?? 10,
    );
  }

  // Create a default provider for new registrations
  factory ServiceProvider.createDefault({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
    required String category,
  }) {
    // Create default business hours (Mon-Fri 9am-5pm, Sat 9am-1pm, Sun closed)
    final List<BusinessHours> defaultHours = [];
    for (int i = 1; i <= 7; i++) {
      if (i <= 5) {
        defaultHours.add(BusinessHours(
          day: i,
          openTime: '09:00',
          closeTime: '17:00',
          isOpen: true,
        ));
      } else if (i == 6) {
        defaultHours.add(BusinessHours(
          day: i,
          openTime: '09:00',
          closeTime: '13:00',
          isOpen: true,
        ));
      } else {
        defaultHours.add(BusinessHours(
          day: i,
          isOpen: false,
        ));
      }
    }

    return ServiceProvider(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      category: category,
      description: 'Welcome to $name!',
      logoUrl: '', // Default logo will be shown
      businessHours: defaultHours,
      latitude: '0',
      longitude: '0',
      amenities: [],
      paymentMethods: ['Cash', 'Credit Card'],
      capacityPerDay: 10,
    );
  }
}
