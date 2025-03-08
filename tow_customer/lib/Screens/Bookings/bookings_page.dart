import 'package:flutter/material.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/Service.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/constants.dart';
import 'package:intl/intl.dart';

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

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Upcoming', 'Past', 'Cancelled'];

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
    if (status == 'Upcoming') {
      return widget.bookings
          .where((booking) =>
              booking.status == 'Pending' || booking.status == 'Confirmed')
          .toList();
    } else if (status == 'Past') {
      return widget.bookings
          .where((booking) => booking.status == 'Completed')
          .toList();
    } else {
      return widget.bookings
          .where((booking) => booking.status == 'Cancelled')
          .toList();
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

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Pending':
        color = Colors.orange;
        icon = Icons.access_time;
        break;
      case 'Confirmed':
        color = Colors.blue;
        icon = Icons.check_circle;
        break;
      case 'Completed':
        color = Colors.green;
        icon = Icons.done_all;
        break;
      case 'Cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      avatar: Icon(icon, color: Colors.white, size: 16),
    );
  }

  String _formatTimeOfDay(TimeOfDay? time, BuildContext context) {
    if (time == null) return 'N/A';
    return time.format(context);
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
                        : status == 'Past'
                            ? Icons.history
                            : Icons.cancel,
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
              final provider =
                  _getServiceProviderById(booking.serviceProviderId);
              final service =
                  _getServiceById(booking.serviceProviderId, booking.serviceId);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: pet.imageUrl.isNotEmpty
                            ? NetworkImage(pet.imageUrl)
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: pet.imageUrl.isEmpty
                            ? Icon(Icons.pets, color: Colors.grey[600])
                            : null,
                      ),
                      title: Text(
                        service?.name ?? 'Unknown Service',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(provider.name),
                      trailing: _buildStatusChip(booking.status),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          const Divider(),
                          _buildInfoRow(
                            'Pet',
                            pet.name,
                            Icons.pets,
                          ),
                          _buildInfoRow(
                            'Date',
                            DateFormat('EEEE, MMMM d, yyyy')
                                .format(booking.date),
                            Icons.calendar_today,
                          ),
                          if (booking.days > 1)
                            _buildInfoRow(
                              'Duration',
                              '${booking.days} days',
                              Icons.date_range,
                            )
                          else
                            _buildInfoRow(
                              'Time',
                              booking.endTime != null
                                  ? '${_formatTimeOfDay(booking.startTime, context)} - ${_formatTimeOfDay(booking.endTime, context)}'
                                  : _formatTimeOfDay(
                                      booking.startTime, context),
                              Icons.access_time,
                            ),
                          _buildInfoRow(
                            'Total',
                            'RM ${booking.totalPrice.toStringAsFixed(2)}',
                            Icons.attach_money,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (status == 'Upcoming')
                                TextButton(
                                  onPressed: () {
                                    // Show cancel confirmation dialog
                                    _showCancelDialog(booking);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                ),
                                onPressed: () {
                                  // Show booking details
                                  _showBookingDetailsDialog(booking);
                                },
                                child: const Text('View Details'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              // Update booking status to cancelled
              setState(() {
                int index =
                    widget.bookings.indexWhere((b) => b.id == booking.id);
                if (index != -1) {
                  // In a real app, we would update the booking on the server
                  // For now, we'll just update our local copy
                  widget.bookings[index] = Booking(
                    id: booking.id,
                    userId: booking.userId,
                    petId: booking.petId,
                    serviceProviderId: booking.serviceProviderId,
                    serviceId: booking.serviceId,
                    date: booking.date,
                    startTime: booking.startTime,
                    endTime: booking.endTime,
                    status: 'Cancelled',
                    days: booking.days,
                    totalPrice: booking.totalPrice,
                    notes: booking.notes,
                  );
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking has been cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetailsDialog(Booking booking) {
    final pet = _getPetById(booking.petId);
    final provider = _getServiceProviderById(booking.serviceProviderId);
    final service =
        _getServiceById(booking.serviceProviderId, booking.serviceId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Provider
              Text(
                provider.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                provider.category,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // Service
              const Text(
                'Service',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(service?.name ?? 'Unknown Service'),
              const SizedBox(height: 8),

              // Pet
              const Text(
                'Pet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${pet.name} (${pet.breed})'),
              const SizedBox(height: 8),

              // Date and Time
              const Text(
                'Appointment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(DateFormat('EEEE, MMMM d, yyyy').format(booking.date)),
              if (booking.days > 1)
                Text('Duration: ${booking.days} days')
              else
                Text(booking.endTime != null
                    ? 'Time: ${_formatTimeOfDay(booking.startTime, context)} - ${_formatTimeOfDay(booking.endTime, context)}'
                    : 'Time: ${_formatTimeOfDay(booking.startTime, context)}'),
              const SizedBox(height: 8),

              // Price
              const Text(
                'Payment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Total: RM ${booking.totalPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 8),

              // Status
              const Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildStatusChip(booking.status),
                ],
              ),

              // Notes (if any)
              if (booking.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(booking.notes),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
