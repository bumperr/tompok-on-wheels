import 'package:flutter/material.dart';

class Pet {
  final String name;
  final String imageUrl;
  final double distance; // Distance in meters or km
  final Color backgroundColor;

  Pet({
    required this.name,
    required this.imageUrl,
    required this.distance,
    required this.backgroundColor,
  });
}

class PetProfileScreen extends StatelessWidget {
  final List<Pet> pets = [
    Pet(
      name: "Siri",
      imageUrl: "https://via.placeholder.com/80",
      distance: 1200, // 1.2 Km
      backgroundColor: Colors.green[100]!,
    ),
    Pet(
      name: "Calico",
      imageUrl: "https://via.placeholder.com/80",
      distance: 300, // 300 meters
      backgroundColor: Colors.orange[100]!,
    ),
  ];

  PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Your Pet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Pet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("See All"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pets
                  .map((pet) => Expanded(
                        child: PetCard(pet: pet),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pet.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(pet.imageUrl),
                radius: 24,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            pet.name,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            "Distance ${pet.name} from you",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            pet.distance >= 1000
                ? "${(pet.distance / 1000).toStringAsFixed(1)} Km"
                : "${pet.distance.toInt()} m",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Center(
              child: Text("Track", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: PetProfileScreen()));
}
