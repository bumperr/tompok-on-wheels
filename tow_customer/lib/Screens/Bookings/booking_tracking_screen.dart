import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/constants.dart';

import 'package:intl/intl.dart';

class BookingTrackingScreen extends StatefulWidget {
  final Booking booking;
  final Pet pet;
  final ServiceProvider serviceProvider;

  const BookingTrackingScreen({
    Key? key,
    required this.booking,
    required this.pet,
    required this.serviceProvider,
  }) : super(key: key);

  @override
  _BookingTrackingScreenState createState() => _BookingTrackingScreenState();
}

class _BookingTrackingScreenState extends State<BookingTrackingScreen> {
  late GoogleMapController _mapController;

  // Simulated tracking data (to be replaced with real GPS tracking)
  final LatLng _currentLocation =
      const LatLng(4.2105, 101.9758); // Example location in Malaysia
  final LatLng _pickupLocation = const LatLng(4.2100, 101.9750);
  final LatLng _dropoffLocation = const LatLng(4.2110, 101.9765);

  final List<TrackingStep> _trackingSteps = [
    TrackingStep(
      title: 'Booking Confirmed',
      description: 'Your pet transportation booking is confirmed',
      isCompleted: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TrackingStep(
      title: 'Driver Assigned',
      description: 'A professional driver has been assigned to your booking',
      isCompleted: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    TrackingStep(
      title: 'En Route to Pickup',
      description: 'Driver is on the way to pick up your pet',
      isCompleted: false,
      timestamp: null,
    ),
    TrackingStep(
      title: 'Pet Pickup',
      description: 'Pet picked up and journey started',
      isCompleted: false,
      timestamp: null,
    ),
    TrackingStep(
      title: 'En Route to Destination',
      description: 'Traveling to the destination',
      isCompleted: false,
      timestamp: null,
    ),
    TrackingStep(
      title: 'Destination Reached',
      description: 'Pet safely delivered',
      isCompleted: false,
      timestamp: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Adaptive App Bar
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Booking Tracking',
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              background: _buildMapView(),
            ),
            backgroundColor: kPrimaryColor,
          ),

          // Booking Summary
          SliverToBoxAdapter(
            child: _buildBookingSummaryCard(),
          ),

          // Tracking Timeline
          SliverList(
            delegate: SliverChildListDelegate([
              _buildTrackingTimeline(),
            ]),
          ),

          // Driver Details
          SliverToBoxAdapter(
            child: _buildDriverDetailsCard(),
          ),

          // Action Buttons
          SliverToBoxAdapter(
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentLocation,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
        Marker(
          markerId: const MarkerId('pickup_location'),
          position: _pickupLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
        Marker(
          markerId: const MarkerId('dropoff_location'),
          position: _dropoffLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Dropoff Location'),
        ),
      },
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }

  Widget _buildBookingSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Information
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.pet.imageUrl.isNotEmpty
                      ? NetworkImage(widget.pet.imageUrl)
                      : null,
                  child: widget.pet.imageUrl.isEmpty
                      ? const Icon(Icons.pets, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.pet.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${widget.pet.breed} | ${widget.pet.age} years',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Booking Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Service Provider'),
                Text(
                  widget.serviceProvider.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Booking Date'),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a')
                      .format(widget.booking.date),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Price'),
                Text(
                  'RM ${widget.booking.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tracking Timeline',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _trackingSteps.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final step = _trackingSteps[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: step.isCompleted ? kPrimaryColor : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      step.isCompleted ? Icons.check : Icons.circle,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: step.isCompleted ? kPrimaryColor : Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.description),
                      if (step.timestamp != null)
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a')
                              .format(step.timestamp!),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverDetailsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://example.com/driver-avatar.jpg',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Vehicle: Blue Van | Plate: ABC 1234',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone_rounded, color: kPrimaryColor),
                  onPressed: () {
                    // Implement phone call functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.chat),
            label: const Text('Contact Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              // Implement support chat
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel Booking'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              _showCancelBookingDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showCancelBookingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? '
          'A cancellation fee may apply depending on the current status.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Implement booking cancellation logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

// Tracking Step Class
class TrackingStep {
  final String title;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;

  TrackingStep({
    required this.title,
    required this.description,
    this.timestamp,
    this.isCompleted = false,
  });
}
