import 'package:flutter/material.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/Service.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/constants.dart';
import 'package:intl/intl.dart';
import 'package:tow_customer/Screens/Bookings/booking_tracking_screen.dart';

class BookingsPage extends StatefulWidget {
  final List<Booking> bookings;
  final List<Pet> pets;
  final List<ServiceProvider> serviceProviders;
  final Map<String, List<Service>> services;

  const BookingsPage({
    Key? key,
    required this.bookings,
    required this.pets,
    required this.serviceProviders,
    required this.services,
  }) : super(key: key);

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Upcoming', 'In Progress', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Booking> _filterBookings(String status) {
    switch (status) {
      case 'Upcoming':
        return widget.bookings
            .where((booking) => 
              booking.status == 'Pending' || 
              booking.status == 'Confirmed')
            .toList();
      case 'In Progress':
        return widget.bookings
            .where((booking) => booking.status == 'In Transit')
            .toList();
      case 'Completed':
        return widget.bookings
            .where((booking) => booking.status == 'Completed')
            .toList();
      case 'Cancelled':
        return widget.bookings
            .where((booking) => booking.status == 'Cancelled')
            .toList();
      default:
        return [];
    }
  }

  Pet _getPetById(String petId) {
    try {
      return widget.pets.firstWhere((pet) => pet.id == petId);
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
      return widget.serviceProviders
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
      if (widget.services.containsKey(providerId)) {
        return widget.services[providerId]!
            .firstWhere((service) => service.id == serviceId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'In Transit':
        return Colors.green;
      case 'Completed':
        return Colors.green.shade700;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showBookingDetailsDialog(Booking booking) {
    final pet = _getPetById(booking.petId);
    final provider = _getServiceProviderById(booking.serviceProviderId);
    final service = _getServiceById(booking.serviceProviderId, booking.serviceId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(
                        color: _getStatusColor(booking.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(booking.date),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pet Information
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: pet.imageUrl.isNotEmpty
                        ? NetworkImage(pet.imageUrl)
                        : null,
                    child: pet.imageUrl.isEmpty
                        ? const Icon(Icons.pets, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${pet.breed} | ${pet.age} years',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Service Provider Details
              const Text(
                'Service Provider',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(provider.logoUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          provider.category,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Service Details
              const Text(
                'Service',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                service?.name ?? 'Unknown Service',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (service?.description != null)
                Text(
                  service!.description,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              const SizedBox(height: 16),

              // Pricing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Price'),
                  Text(
                    'RM ${booking.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (booking.status == 'In Transit')
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                _navigateToTracking(booking);
              },
              child: const Text('Track Booking'),
            ),
        ],
      ),
    );
  }

  void _navigateToTracking(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingTrackingScreen(
          booking: booking,
          pet: _getPetById(booking.petId),
          serviceProvider: _getServiceProviderById(booking.serviceProviderId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((label) => Tab(text: label)).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((status) {
          final filteredBookings = _filterBookings(status);

          if (filteredBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    status == 'Upcoming'
                        ? Icons.event_available
                        : status == 'Completed'
                            ? Icons.check_circle
                            : status == 'Cancelled'
                                ? Icons.cancel
                                : Icons.pending,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No $status bookings',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredBookings.length,
            itemBuilder: (context, index) {
              final booking = filteredBookings[index];
              final pet = _getPetById(booking.petId);
              final provider = _getServiceProviderById(booking.serviceProviderId);
              final service = _getServiceById(booking.serviceProviderId, booking.serviceId);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status and Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking.status,
                              style: TextStyle(
                                color: _getStatusColor(booking.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(booking.date),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pet and Service Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: pet.imageUrl.isNotEmpty
                                ? NetworkImage(pet.imageUrl)
                                : null,
                            child: pet.imageUrl.isEmpty
                                ? const Icon(Icons.pets, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 16),
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
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.name,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'RM ${booking.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kPrimaryColor,
                                side: BorderSide(color: kPrimaryColor),
                              ),
                              onPressed: () => _showBookingDetailsDialog(booking),
                              child: const Text('View Details'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (booking.status == 'In Transit')
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                ),
                                onPressed: () => _navigateToTracking(booking),
                                child: const Text('Track Booking'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}