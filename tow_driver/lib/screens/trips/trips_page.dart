// lib/screens/trips/trips_page.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';
import 'package:tow_driver/class/trip.dart';
import 'package:tow_driver/data/sample_data.dart';
import 'package:tow_driver/screens/trip_details/trip_details_screen.dart';
import 'package:intl/intl.dart';

class TripsPage extends StatefulWidget {
  final List<Trip> trips;

  const TripsPage({
    Key? key,
    required this.trips,
  }) : super(key: key);

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Active', 'Upcoming', 'Completed', 'Cancelled'];
  
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

  List<Trip> _filterTrips(String filter) {
    switch (filter) {
      case 'Active':
        return widget.trips
            .where((trip) => trip.status == TripStatus.accepted || 
                           trip.status == TripStatus.enRouteToPickup ||
                           trip.status == TripStatus.arrived ||
                           trip.status == TripStatus.inProgress)
            .toList();
      case 'Upcoming':
        return widget.trips
            .where((trip) => trip.status == TripStatus.pending)
            .toList();
      case 'Completed':
        return widget.trips
            .where((trip) => trip.status == TripStatus.completed)
            .toList();
      case 'Cancelled':
        return widget.trips
            .where((trip) => trip.status == TripStatus.cancelled)
            .toList();
      default:
        return widget.trips;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _tabs.map((label) => Tab(text: label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((filter) {
          final filteredTrips = _filterTrips(filter);
          return TripList(
            trips: filteredTrips,
            emptyStateMessage: 'No ${filter.toLowerCase()} trips',
            emptyStateIcon: _getEmptyStateIcon(filter),
          );
        }).toList(),
      ),
    );
  }

  IconData _getEmptyStateIcon(String filter) {
    switch (filter) {
      case 'Active':
        return Icons.directions_car;
      case 'Upcoming':
        return Icons.schedule;
      case 'Completed':
        return Icons.check_circle;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.list;
    }
  }
}

class TripList extends StatelessWidget {
  final List<Trip> trips;
  final String emptyStateMessage;
  final IconData emptyStateIcon;

  const TripList({
    Key? key,
    required this.trips,
    required this.emptyStateMessage,
    required this.emptyStateIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              emptyStateIcon,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              emptyStateMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildTripCard(context, trip);
      },
    );
  }

  Widget _buildTripCard(BuildContext context, Trip trip) {
    final formattedDate = DateFormat('EEEE, MMMM d').format(trip.date);
    final formattedTime = trip.startTime.format(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDetailsScreen(
                trip: trip,
                checklist: samplePetChecklist,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(trip.status),
                  Text(
                    '$formattedDate • $formattedTime',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Pet and service details
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(trip.petImageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.petName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          trip.serviceName,
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'RM ${trip.driverEarnings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${trip.distance.toStringAsFixed(1)} km',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Locations
              Row(
                children: [
                  Container(
                    height: 70,
                    width: 24,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 12,
                        ),
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.grey[300],
                          ),
                        ),
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.pickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          trip.destinationAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Action buttons based on status
              if (trip.status == TripStatus.pending)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () {
                            // Decline trip logic
                            _showDeclineTripDialog(context);
                          },
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            // Accept trip logic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripDetailsScreen(
                                  trip: trip,
                                  checklist: samplePetChecklist,
                                ),
                              ),
                            );
                          },
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(TripStatus status) {
    late Color color;
    late String text;
    
    switch (status) {
      case TripStatus.pending:
        color = Colors.orange;
        text = "Pending";
        break;
      case TripStatus.accepted:
        color = Colors.blue;
        text = "Accepted";
        break;
      case TripStatus.enRouteToPickup:
        color = Colors.purple;
        text = "En Route to Pickup";
        break;
      case TripStatus.arrived:
        color = Colors.amber;
        text = "Arrived";
        break;
      case TripStatus.inProgress:
        color = Colors.green;
        text = "In Progress";
        break;
      case TripStatus.completed:
        color = Colors.teal;
        text = "Completed";
        break;
      case TripStatus.cancelled:
        color = Colors.red;
        text = "Cancelled";
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showDeclineTripDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Trip'),
        content: const Text(
          'Are you sure you want to decline this trip? '
          'This action cannot be undone and may affect your acceptance rate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would call an API to decline the trip
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trip declined'),
                ),
              );
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}