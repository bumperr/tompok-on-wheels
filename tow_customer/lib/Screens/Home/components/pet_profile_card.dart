import 'package:flutter/material.dart';
import 'package:tow_customer/class/Pet.dart';

class PetSection extends StatelessWidget {
  final List<Pet> pets;
  const PetSection({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.9;
    final cardHeight = screenSize.height * 0.4; // Adjusted height

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Header ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Pet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_box_outlined,
                            color: Colors.grey),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ---- Pet List ----
              Expanded(
                child: pets.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          return PetCard(
                            pet: pets[index],
                            petStatusIndex: index, // Keep index-based color
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "No pets added yet.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Pet Card ---
class PetCard extends StatelessWidget {
  final Pet pet;
  final int petStatusIndex;

  const PetCard({
    super.key,
    required this.pet,
    required this.petStatusIndex,
  });

  Color _getStatusColor() {
    switch (petStatusIndex) {
      case 0:
        return Colors.green.shade100;
      case 1:
        return Colors.orange.shade100;
      case 2:
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getStatusColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Pet Image
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(pet.imageUrl),
                ),

                const SizedBox(width: 10),

                // Name and Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pet.size, // Status placeholder
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                // Three-dot Button
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 10),

            // View More Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {},
                child: const Text(
                  "View More",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
