import 'package:flutter/material.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/Screens/Home/components/service_provider_details_screen.dart';

class ServiceProviderSection extends StatefulWidget {
  final List<ServiceProvider> serviceProviders;

  const ServiceProviderSection({super.key, required this.serviceProviders});

  @override
  _ServiceProviderSectionState createState() => _ServiceProviderSectionState();
}

class _ServiceProviderSectionState extends State<ServiceProviderSection> {
  String _selectedCategory = '';
  double _selectedDistance = 10.0; // Default 10 km range
  final List<String> _categories = ['Veterinary', 'Grooming', 'Boarding'];
  final List<double> _distanceRanges = [5.0, 10.0, 20.0, 50.0];

  List<ServiceProvider> _filterProviders() {
    return widget.serviceProviders.where((provider) {
      bool categoryMatch =
          _selectedCategory.isEmpty || provider.category == _selectedCategory;

      bool distanceMatch =
          provider.distance != null && provider.distance! <= _selectedDistance;

      return categoryMatch && distanceMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.9;

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0), // Added top padding
      child: Card(
        elevation: 4,
        color: Colors.white, // Changed card color to white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Service Providers",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Location Range Dropdown
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.blue, size: 16),
                        const SizedBox(width: 4),
                        DropdownButton<double>(
                          underline: Container(), // Remove underline
                          hint: const Text('Distance'),
                          value: _selectedDistance,
                          items: _distanceRanges.map((range) {
                            return DropdownMenuItem(
                              value: range,
                              child: Text('${range.toStringAsFixed(0)} km'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDistance = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = selected ? category : '';
                          });
                        },
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: _selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Filtered Service Provider List
              Builder(
                builder: (context) {
                  final filteredProviders = _filterProviders();

                  if (filteredProviders.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No service providers found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: filteredProviders.map((provider) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ServiceProviderCard(serviceProvider: provider),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceProviderCard extends StatelessWidget {
  final ServiceProvider serviceProvider;

  const ServiceProviderCard({
    super.key,
    required this.serviceProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              serviceProvider.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            serviceProvider.isVerified
                                ? Icons.verified
                                : Icons.verified_outlined,
                            color: serviceProvider.isVerified
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        serviceProvider.category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${serviceProvider.rating ?? 0.0}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${serviceProvider.distance ?? 0} km | ${serviceProvider.travelTime ?? 0} min',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Services Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // TODO: Navigate to service details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceProviderDetailsScreen(
                      serviceProvider: serviceProvider,
                    ),
                  ),
                );
              },
              child: const Text(
                'View Services',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
