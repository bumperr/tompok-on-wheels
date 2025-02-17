import 'package:flutter/material.dart';
import 'package:tow_customer/Screens/Home/components/user_profile.dart';
import 'package:tow_customer/components/bottom_navigation.dart';
import 'dart:convert';
import 'package:tow_customer/class/User.dart';
import 'package:tow_customer/class/Pet.dart';

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

//------------Example ---------------------------------

// Parse JSON data into List<Pet>
List<dynamic> petsJson = jsonDecode(jsonData);
// ignore: unused_local_variable
List<Pet> pets = petsJson.map((petJson) => Pet.fromJson(petJson)).toList();

//----------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  //edit here for page
  final List<Widget> _pages = [
    UserHome(user: john, petList: pets),
    Center(child: Text('Services Page')),
    Center(child: Text('Track Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
//--------------------------Example of page pet profile ----------------------------
// PetProfileScreen(
//       pets: [
//         Pet(
//           name: 'Oyenz',
//           breed: 'Tabby Cat',
//           age: 3,
//           imageUrl:
//               'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe4jd3oWsdmEPVlfUtU0o8rcENg2nNdUDspQ&s',
//           description: 'A friendly and energetic troublemaker',
//         ),
//         Pet(
//           name: 'Whiskers',
//           breed: 'Siamese Cat',
//           age: 5,
//           imageUrl:
//               'https://preview.redd.it/955h4hhrz2781.jpg?width=1080&crop=smart&auto=webp&s=cc0e622bd4ac22fef887b8a77130014da81fbec0',
//           description: 'A calm and affectionate siamese cat...',
//         ),
//       ],
//     ),
