import 'package:flutter/material.dart';

class Pet {
  final String name;
  final String breed;
  final int age;
  final String imageUrl;
  final String description;

  Pet({
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.description,
  });
}

class PetProfileScreen extends StatefulWidget {
  final List<Pet> pets;

  const PetProfileScreen({super.key, required this.pets});

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final PageController _pageController = PageController();
  // ignore: unused_field
  int _currentPageIndex = 0;
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.pets.length,
        itemBuilder: (context, index) {
          final pet = widget.pets[index];
          return Column(
            children: [
              const SizedBox(height: 2), // Adjust the height as needed
              PetCard(
                pet: pet,
                isExpanded: _isExpanded,
                onTap: _toggleExpanded,
              ),
            ],
          );
        },
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;
  final bool isExpanded;
  final VoidCallback onTap;

  const PetCard({
    super.key,
    required this.pet,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 1; // 80% of screen width
    final cardHeight = screenSize.height * 0.33; // 30% of screen height
    return Center(
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                ClipOval(
                  child: Image.network(
                    pet.imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Breed: ${pet.breed}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Age: ${pet.age} years',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Handle edit action
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.view_agenda),
                                  onPressed: () {
                                    // Handle view action
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage:
void main() {
  runApp(MaterialApp(
    home: PetProfileScreen(
      pets: [
        Pet(
          name: 'Oyenz',
          breed: 'Tabby Cat',
          age: 3,
          imageUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe4jd3oWsdmEPVlfUtU0o8rcENg2nNdUDspQ&s',
          description: 'A friendly and energetic troublemaker',
        ),
        Pet(
          name: 'Whiskers',
          breed: 'Siamese Cat',
          age: 5,
          imageUrl:
              'https://preview.redd.it/955h4hhrz2781.jpg?width=1080&crop=smart&auto=webp&s=cc0e622bd4ac22fef887b8a77130014da81fbec0',
          description: 'A calm and affectionate siamese cat...',
        ),
      ],
    ),
  ));
}
