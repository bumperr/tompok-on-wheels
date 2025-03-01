import 'package:flutter/material.dart';
import 'package:tow_customer/Screens/Home/components/user_profile.dart';
import 'package:tow_customer/Screens/Profile/profile_page.dart';
import 'package:tow_customer/components/bottom_navigation.dart';
import 'dart:convert';
import 'package:tow_customer/class/User.dart';
import 'package:tow_customer/class/Pet.dart';
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
  }

  // Add new pet
  void _addPet(Pet newPet) {
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    // Create pages list inside build method to access the current state
    final List<Widget> pages = [
      UserHome(
        user: john,
        petList: pets,
        serviceProviders: sampleServiceProviders,
        onPetAdded: _addPet,
        onPetUpdated: _updatePet,
        onEditProfile: _navigateToProfile,
      ),
      Center(child: Text('Services Page')),
      Center(child: Text('Track Page')),
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

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
