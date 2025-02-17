import 'package:flutter/material.dart';
import 'package:tow_customer/class/User.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/constants.dart';
import 'package:tow_customer/Screens/Home/components/pet_profile_card.dart';

class UserHome extends StatelessWidget {
  final User user;
  final List<Pet> petList;

  const UserHome({
    super.key,
    required this.user,
    required this.petList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserProfileSection(user: user),
        PetSection(pets: petList),
      ],
    );
  }
}

class UserProfileSection extends StatelessWidget {
  final User user;

  const UserProfileSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.9;
    final cardHeight = screenSize.height * 0.15;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile Image
              CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 50,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage:
                      const AssetImage('assets/images/john_doe.jpg'),
                ),
              ),
              const SizedBox(width: 30),

              // User Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${user.name}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${user.id}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.location,
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Icon
              IconButton(
                icon: const Icon(Icons.edit, size: 20), // Reduce icon size
                color: Colors.grey,
                onPressed: () {
                  // Onpressed logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
