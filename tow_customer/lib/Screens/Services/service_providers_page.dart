import 'package:flutter/material.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/Service.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/constants.dart';
import 'package:tow_customer/Screens/Home/components/service_provider_details_screen.dart';

class ServiceProvidersPage extends StatefulWidget {
  final List<ServiceProvider> serviceProviders;
  final List<Pet> pets;
  final String userId;
  final Map<String, List<Service>> services;
  final Function(Booking) onBookingAdded;

  const ServiceProvidersPage({
    Key? key,
    required this.serviceProviders,
    required this.pets,
    required this.userId,
    required this.services,
    required this.onBookingAdded,
  }) : super(key: key);

  @override
  _ServiceProvidersPageState createState() => _ServiceProvidersPageState();
}

class _ServiceProvidersPageState extends State<ServiceProvidersPage> {
  String _selectedCategory = '';
  double _selectedDistance = 10.0;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Providers'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search and filters section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for services or providers',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),

                const SizedBox(height: 16),

                // Category Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // Distance filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

                const SizedBox(height: 12),

                // Category filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: _selectedCategory.isEmpty,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategory = '';
                            });
                          },
                          selectedColor: kPrimaryColor,
                          backgroundColor: Colors.grey[200],
                          labelStyle: TextStyle(
                            color: _selectedCategory.isEmpty
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      ..._categories.map((category) {
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
                            selectedColor: kPrimaryColor,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: _selectedCategory == category
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider between search and results
          Container(
            height: 4,
            width: double.infinity,
            color: Colors.grey[200],
          ),

          // Service provider list
          Expanded(
            child: Builder(
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

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProviders.length,
                  itemBuilder: (context, index) {
                    final provider = filteredProviders[index];
                    return _buildServiceProviderCard(provider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceProviderCard(ServiceProvider provider) {
    // Check if this provider has services
    final hasServices = widget.services.containsKey(provider.id);
    final providerServices = hasServices ? widget.services[provider.id]! : [];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider Image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(provider.logoUrl),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {
                  // Fallback
                },
              ),
            ),
            child: Stack(
              children: [
                // Gradient overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Category badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      provider.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Verified badge
                if (provider.isVerified)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 16,
                      ),
                    ),
                  ),
                // Provider Name
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    provider.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Provider Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating & Distance Row
                Row(
                  children: [
                    // Rating
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.rating ?? 0.0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Distance
                    Icon(Icons.location_on, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.distance ?? 0} km | ${provider.travelTime ?? 0} min',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Services Preview (show first 3 if available)
                if (hasServices && providerServices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Services',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...providerServices.take(3).map((service) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'RM ${service.price.toStringAsFixed(2)}${service.isPricePerDay ? '/day' : ''}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      
                      if (providerServices.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+ ${providerServices.length - 3} more services',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 12),

                // View Details Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceProviderDetailsScreen(
                            serviceProvider: provider,
                            pets: widget.pets,
                            userId: widget.userId,
                            onBookingAdded: widget.onBookingAdded,
                            services: hasServices ? providerServices.cast<Service>() : null,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'View Details',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}