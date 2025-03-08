import 'package:flutter/material.dart';
import 'package:tow_customer/Screens/Home/components/user_profile.dart';
import 'package:tow_customer/Screens/Profile/profile_page.dart';
import 'package:tow_customer/components/bottom_navigation.dart';
import 'package:tow_customer/Screens/Bookings/bookings_page.dart';
import 'package:tow_customer/Screens/Services/service_providers_page.dart';
import 'dart:convert';
import 'package:tow_customer/class/User.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/Service.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/class/ServiceProvider.dart';

//--------------sample data----------------
User john = User(
    id: 'johnthecatlover',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phoneNumber: '123-456-7890',
    imageUrl: '',
    location: 'Seri Iskandar, Perak');

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

// Fake Service Provider Data for Malaysian Context
final List<ServiceProvider> sampleServiceProviders = [
  ServiceProvider(
    id: 'vet001',
    name: 'Happy Paws Veterinary Clinic',
    category: 'Veterinary',
    logoUrl: 'https://storage.googleapis.com/tow-assets/clinics/happy_paws.jpg',
    isVerified: true,
    rating: 4.7,
    distance: 2.3,
    travelTime: 12,
  ),
  ServiceProvider(
    id: 'groomer002',
    name: 'Purr-fect Grooming Salon',
    category: 'Grooming',
    logoUrl:
        'https://storage.googleapis.com/tow-assets/groomers/purrfect_salon.jpg',
    isVerified: true,
    rating: 4.5,
    distance: 3.7,
    travelTime: 20,
  ),
  ServiceProvider(
    id: 'boarding003',
    name: 'Cozy Cats Retreat',
    category: 'Boarding',
    logoUrl: 'https://storage.googleapis.com/tow-assets/boarding/cozy_cats.jpg',
    isVerified: true,
    rating: 4.2,
    distance: 5.5,
    travelTime: 30,
  ),
  ServiceProvider(
    id: 'vet004',
    name: 'Seri Iskandar Animal Hospital',
    category: 'Veterinary',
    logoUrl:
        'https://storage.googleapis.com/tow-assets/clinics/seri_iskandar_vet.jpg',
    isVerified: false,
    rating: 4.0,
    distance: 1.8,
    travelTime: 10,
  ),
  ServiceProvider(
    id: 'groomer005',
    name: 'Whiskers & Paws Grooming',
    category: 'Grooming',
    logoUrl:
        'https://storage.googleapis.com/tow-assets/groomers/whiskers_paws.jpg',
    isVerified: true,
    rating: 4.6,
    distance: 4.2,
    travelTime: 25,
  )
];

// Sample services data for different categories
final Map<String, List<Service>> sampleServices = {
  'vet001': [
    Service(
      id: 'v001',
      name: 'Basic Health Check',
      description:
          'General health assessment including temperature, weight, heart rate, and visual examination.',
      category: 'veterinary',
      price: 80.00,
      duration: 30,
    ),
    Service(
      id: 'v002',
      name: 'Vaccination',
      description:
          'Administration of core vaccines to protect against common diseases.',
      category: 'veterinary',
      price: 120.00,
      duration: 15,
    ),
    Service(
      id: 'v003',
      name: 'Dental Cleaning',
      description:
          'Professional cleaning to remove plaque and tartar from teeth.',
      category: 'veterinary',
      price: 250.00,
      duration: 60,
    ),
    Service(
      id: 'v004',
      name: 'Microchipping',
      description: 'Implantation of a microchip for permanent identification.',
      category: 'veterinary',
      price: 60.00,
      duration: 10,
    ),
  ],
  'vet004': [
    Service(
      id: 'v101',
      name: 'General Consultation',
      description: 'Basic consultation for general health concerns.',
      category: 'veterinary',
      price: 70.00,
      duration: 30,
    ),
    Service(
      id: 'v102',
      name: 'Annual Vaccination',
      description: 'Yearly vaccination package including examination.',
      category: 'veterinary',
      price: 130.00,
      duration: 20,
    ),
    Service(
      id: 'v103',
      name: 'Deworming',
      description: 'Treatment to eliminate internal parasites.',
      category: 'veterinary',
      price: 50.00,
      duration: 15,
    ),
  ],
  'groomer002': [
    Service(
      id: 'g001',
      name: 'Basic Cat Bath',
      description:
          'Gentle bath with cat-friendly shampoo, blow dry, and basic brushing.',
      category: 'grooming',
      price: 60.00,
      duration: 60,
    ),
    Service(
      id: 'g002',
      name: 'Full Grooming Package',
      description:
          'Bath, blow dry, haircut, nail trimming, ear cleaning, and brushing.',
      category: 'grooming',
      price: 120.00,
      duration: 90,
    ),
    Service(
      id: 'g003',
      name: 'Nail Trimming',
      description: 'Professional nail trimming service.',
      category: 'grooming',
      price: 30.00,
      duration: 15,
    ),
  ],
  'groomer005': [
    Service(
      id: 'g101',
      name: 'Premium Cat Grooming',
      description:
          'Luxury grooming service with premium products and extra care.',
      category: 'grooming',
      price: 150.00,
      duration: 120,
      isPremium: true,
    ),
    Service(
      id: 'g102',
      name: 'Express Grooming',
      description:
          'Quick grooming service for cats that need minimal maintenance.',
      category: 'grooming',
      price: 45.00,
      duration: 30,
    ),
  ],
  'boarding003': [
    Service(
      id: 'b001',
      name: 'Standard Boarding',
      description:
          'Comfortable accommodation with regular feeding and basic care.',
      category: 'boarding',
      price: 45.00,
      duration: 1440, // 24 hours in minutes
      isPricePerDay: true,
    ),
    Service(
      id: 'b002',
      name: 'Premium Boarding',
      description:
          'Luxury accommodation with premium food, extra playtime, and special attention.',
      category: 'boarding',
      price: 80.00,
      duration: 1440, // 24 hours in minutes
      isPricePerDay: true,
      isPremium: true,
    ),
    Service(
      id: 'b003',
      name: 'Day Care',
      description: 'Daytime care for your pet while you are away.',
      category: 'boarding',
      price: 30.00,
      duration: 720, // 12 hours in minutes
    ),
  ],
};

// Sample bookings data
List<Booking> sampleBookings = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Pet> pets;
  late User currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = john;

    // Parse JSON data into List<Pet>
    List<dynamic> petsJson = jsonDecode(jsonData);
    pets = petsJson.map((petJson) => Pet.fromJson(petJson)).toList();

    // Add IDs to pets
    for (int i = 0; i < pets.length; i++) {
      pets[i].id = 'pet${i + 1}';
    }

    // Initialize with a sample booking
    sampleBookings.add(
      Booking(
        id: 'book001',
        userId: currentUser.id,
        petId: 'pet1',
        serviceProviderId: 'groomer002',
        serviceId: 'g001',
        date: DateTime.now().add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        status: 'Confirmed',
        totalPrice: 60.00,
      ),
    );
  }

  // Add new pet
  void _addPet(Pet newPet) {
    setState(() {
      newPet.id = 'pet${pets.length + 1}';
      pets.add(newPet);
    });
  }

  // Update existing pet
  void _updatePet(Pet updatedPet, int index) {
    setState(() {
      pets[index] = updatedPet;
    });
  }

  void _updateUser(User updatedUser) {
    setState(() {
      currentUser = updatedUser;
    });
  }

  void _addBooking(Booking booking) {
    setState(() {
      sampleBookings.add(booking);
    });
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          user: currentUser,
          onUserUpdated: _updateUser,
        ),
      ),
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create pages list inside build method to access the current state
    final List<Widget> pages = [
      UserHome(
        user: currentUser,
        petList: pets,
        serviceProviders: sampleServiceProviders,
        services: sampleServices,
        bookings: sampleBookings,
        onPetAdded: _addPet,
        onPetUpdated: _updatePet,
        onBookingAdded: _addBooking,
        onEditProfile: _navigateToProfile,
      ),
      ServiceProvidersPage(
        serviceProviders: sampleServiceProviders,
        pets: pets,
        userId: currentUser.id,
        services: sampleServices,
        onBookingAdded: _addBooking,
      ),
      BookingsPage(
        bookings: sampleBookings,
        pets: pets,
        serviceProviders: sampleServiceProviders,
        services: sampleServices,
      ),
      ProfilePage(
        user: currentUser,
        onUserUpdated: _updateUser,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
