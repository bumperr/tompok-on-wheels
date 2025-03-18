import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';

class Pet {
  final String id;
  final String ownerId;
  final String ownerName;
  final String name;
  final String type;
  final String breed;
  final int age;
  final double weight;
  final String imageUrl;
  final List<String> services;
  final DateTime lastVisit;
  final int totalVisits;
  final String notes;

  Pet({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.weight,
    required this.imageUrl,
    required this.services,
    required this.lastVisit,
    required this.totalVisits,
    this.notes = '',
  });
}

class PetsScreen extends StatefulWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  _PetsScreenState createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  bool _isGridView = true;
  String _searchQuery = '';
  String _selectedType = 'All';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample pets data
  final List<Pet> _pets = [
    Pet(
      id: 'P001',
      ownerId: 'C001',
      ownerName: 'John Doe',
      name: 'Oyen',
      type: 'Cat',
      breed: 'Domestic Shorthair',
      age: 3,
      weight: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
      services: ['Grooming', 'Veterinary'],
      lastVisit: DateTime.now().subtract(const Duration(days: 5)),
      totalVisits: 8,
      notes: 'Friendly, but doesn\'t like water.',
    ),
    Pet(
      id: 'P002',
      ownerId: 'C002',
      ownerName: 'Jane Smith',
      name: 'Tompok',
      type: 'Cat',
      breed: 'Siamese',
      age: 2,
      weight: 3.8,
      imageUrl: 'https://images.unsplash.com/photo-1592194996308-7b43878e84a6',
      services: ['Grooming', 'Boarding'],
      lastVisit: DateTime.now().subtract(const Duration(days: 12)),
      totalVisits: 5,
    ),
    Pet(
      id: 'P003',
      ownerId: 'C003',
      ownerName: 'Wei Lin',
      name: 'Whiskers',
      type: 'Cat',
      breed: 'Persian',
      age: 4,
      weight: 5.2,
      imageUrl: 'https://images.unsplash.com/photo-1573865526739-10659fec78a5',
      services: ['Grooming', 'Veterinary', 'Boarding'],
      lastVisit: DateTime.now().subtract(const Duration(days: 20)),
      totalVisits: 12,
      notes: 'Needs special hypoallergenic shampoo.',
    ),
    Pet(
      id: 'P004',
      ownerId: 'C004',
      ownerName: 'Sarah Johnson',
      name: 'Bella',
      type: 'Cat',
      breed: 'Maine Coon',
      age: 5,
      weight: 6.8,
      imageUrl: 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
      services: ['Grooming', 'Veterinary'],
      lastVisit: DateTime.now().subtract(const Duration(days: 8)),
      totalVisits: 7,
    ),
    Pet(
      id: 'P005',
      ownerId: 'C005',
      ownerName: 'Ahmad Razali',
      name: 'Leo',
      type: 'Cat',
      breed: 'Bengal',
      age: 3,
      weight: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1543852786-1cf6624b9987',
      services: ['Grooming', 'Boarding'],
      lastVisit: DateTime.now().subtract(const Duration(days: 15)),
      totalVisits: 4,
    ),
    Pet(
      id: 'P006',
      ownerId: 'C001',
      ownerName: 'John Doe',
      name: 'Max',
      type: 'Cat',
      breed: 'Ragdoll',
      age: 1,
      weight: 3.2,
      imageUrl: 'https://images.unsplash.com/photo-1494256997604-768d1f608cac',
      services: ['Grooming'],
      lastVisit: DateTime.now().subtract(const Duration(days: 30)),
      totalVisits: 2,
    ),
  ];

  // Filtered pets based on search and filters
  List<Pet> get filteredPets {
    return _pets.where((pet) {
      // Filter by search query
      final matchesSearch = pet.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          pet.ownerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pet.breed.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by pet type
      final matchesType = _selectedType == 'All' || pet.type == _selectedType;

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Pets'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          : null,
      drawer: isSmallScreen
          ? Drawer(
              child: SidebarMenu(
                currentRoute: AppRoutes.petsRoute,
                onMenuItemSelected: () {
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar menu for large screens
          if (!isSmallScreen && _isSidebarOpen)
            SidebarMenu(currentRoute: AppRoutes.petsRoute),

          // Toggle button for sidebar
          if (!isSmallScreen)
            InkWell(
              onTap: () {
                setState(() {
                  _isSidebarOpen = !_isSidebarOpen;
                });
              },
              child: Container(
                width: 24,
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    _isSidebarOpen ? Icons.chevron_left : Icons.chevron_right,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),

          // Main content area
          Expanded(
            child: Container(
              color: kBackgroundColor,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with actions
                  _buildHeader(),

                  // Filter and search row
                  _buildFilterRow(),

                  // Pets grid or list
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _isGridView
                            ? _buildPetsGrid()
                            : _buildPetsList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Pets',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      color: Colors.white,
      child: Row(
        children: [
          // Search field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pets or owners...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),

          // Pet type filter
          DropdownButton<String>(
            value: _selectedType,
            items: ['All', 'Cat', 'Dog', 'Rabbit', 'Bird', 'Others']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
            hint: const Text('Pet Type'),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsGrid() {
    if (filteredPets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No pets found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // Calculate responsive grid
    int crossAxisCount = 3;
    if (MediaQuery.of(context).size.width < 1200) crossAxisCount = 2;
    if (MediaQuery.of(context).size.width < 800) crossAxisCount = 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: filteredPets.length,
        itemBuilder: (context, index) {
          final pet = filteredPets[index];
          return _buildPetCard(pet);
        },
      ),
    );
  }

  Widget _buildPetsList() {
    if (filteredPets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No pets found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView.separated(
        itemCount: filteredPets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final pet = filteredPets[index];
          return _buildPetListItem(pet);
        },
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.petDetailsRoute,
            arguments: pet.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet image
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.network(
                pet.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.pets,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet name and age
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${pet.age} yr${pet.age > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Pet breed and weight
                  Text(
                    '${pet.type} • ${pet.breed}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet.weight} kg',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Owner info
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pet.ownerName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Last visit
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Last visit: ${DateFormat('MMM d, yyyy').format(pet.lastVisit)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // View details button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.petDetailsRoute,
                          arguments: pet.id,
                        );
                      },
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetListItem(Pet pet) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.petDetailsRoute,
            arguments: pet.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pet.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.pets,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Pet details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pet.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${pet.age} yr${pet.age > 1 ? 's' : ''}',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pet breed and weight
                    Row(
                      children: [
                        Text(
                          '${pet.type} • ${pet.breed}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${pet.weight} kg',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Owner info
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pet.ownerName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Last visit and total visits
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Last visit: ${DateFormat('MMM d, yyyy').format(pet.lastVisit)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.pets,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${pet.totalVisits} visits',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.petDetailsRoute,
                        arguments: pet.id,
                      );
                    },
                    tooltip: 'View details',
                    color: kPrimaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Edit pet
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Edit pet not implemented yet')),
                      );
                    },
                    tooltip: 'Edit pet',
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
