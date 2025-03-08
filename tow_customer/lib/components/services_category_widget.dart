import 'package:flutter/material.dart';
import 'package:tow_customer/constants.dart';
import 'package:tow_customer/Screens/Services/service_providers_page.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/Service.dart';
import 'package:tow_customer/class/Booking.dart';

class ServicesCategoryWidget extends StatelessWidget {
  final List<ServiceProvider> serviceProviders;
  final List<Pet> pets;
  final String userId;
  final Map<String, List<Service>> services;
  final Function(Booking) onBookingAdded;

  const ServicesCategoryWidget({
    Key? key,
    required this.serviceProviders,
    required this.pets,
    required this.userId,
    required this.services,
    required this.onBookingAdded,
  }) : super(key: key);

  void _navigateToServiceProviders(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceProvidersPage(
          serviceProviders: category.isEmpty
              ? serviceProviders
              : serviceProviders
                  .where((provider) => provider.category == category)
                  .toList(),
          pets: pets,
          userId: userId,
          services: services,
          onBookingAdded: onBookingAdded,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text(
            "Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildServiceCategory(
                context,
                'Veterinary',
                Icons.medical_services,
                Colors.blue,
              ),
              _buildServiceCategory(
                context,
                'Grooming',
                Icons.content_cut,
                Colors.purple,
              ),
              _buildServiceCategory(
                context,
                'Boarding',
                Icons.home,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
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
              onPressed: () => _navigateToServiceProviders(context, ''),
              child: const Text(
                'View All Service Providers',
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

  Widget _buildServiceCategory(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => _navigateToServiceProviders(context, title),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
