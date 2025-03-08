import 'package:flutter/material.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/class/Service.dart';
import 'package:tow_customer/constants.dart';
import 'package:intl/intl.dart';
import 'package:tow_customer/Screens/Bookings/bookings_page.dart';

class UserBookingsWidget extends StatelessWidget {
  final List<Booking> bookings;
  final List<Pet> pets;
  final List<ServiceProvider> serviceProviders;
  final Map<String, List<Service>> services;

  const UserBookingsWidget({
    Key? key,
    required this.bookings,
    required this.pets,
    required this.serviceProviders,
    required this.services,
  }) : super(key: key);

  Pet _getPetById(String petId) {
    try {
      return pets.firstWhere((pet) => pet.id == petId);
    } catch (e) {
      return Pet(
        id: 'unknown',
        name: 'Unknown Pet',
        weight: 0,
        size: 'Unknown',
        age: 0,
        imageUrl: '',
        breed: 'Unknown',
        notes: [],
      );
    }
  }

  ServiceProvider _getServiceProviderById(String providerId) {
    try {
      return serviceProviders
          .firstWhere((provider) => provider.id == providerId);
    } catch (e) {
      return ServiceProvider(
        id: 'unknown',
        name: 'Unknown Provider',
        category: 'Unknown',
        logoUrl: '',
        isVerified: false,
      );
    }
  }

  Service? _getServiceById(String providerId, String serviceId) {
    try {
      if (services.containsKey(providerId)) {
        return services[providerId]!
            .firstWhere((service) => service.id == serviceId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  List<Booking> _getUpcomingBookings() {
    // Filter for upcoming bookings (Pending or Confirmed status)
    final upcoming = bookings
        .where((booking) =>
            (booking.status == 'Pending' || booking.status == 'Confirmed') &&
            booking.date
                .isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .toList();

    // Sort by date (earliest first)
    upcoming.sort((a, b) => a.date.compareTo(b.date));

    // Take only the next 3 bookings
    return upcoming.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final upcomingBookings = _getUpcomingBookings();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Upcoming Bookings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to bookings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingsPage(
                        bookings: bookings,
                        pets: pets,
                        serviceProviders: serviceProviders,
                        services: services,
                      ),
                    ),
                  );
                },
                child: const Text("See All"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          upcomingBookings.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "No upcoming bookings",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : Column(
                  children: upcomingBookings.map((booking) {
                    final pet = _getPetById(booking.petId);
                    final provider =
                        _getServiceProviderById(booking.serviceProviderId);
                    final service = _getServiceById(
                        booking.serviceProviderId, booking.serviceId);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Left side: Date indicator
                            Container(
                              width: 50,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('dd').format(booking.date),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM').format(booking.date),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Right side: Booking details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service?.name ?? 'Unknown Service',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.business,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          provider.name,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.pets,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        pet.name,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (!booking.isBoardingService())
                                        Text(
                                          booking.startTime.format(context),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
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
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

// Extension to check if booking is for boarding
extension BookingExtension on Booking {
  bool isBoardingService() {
    return days > 1;
  }
}
