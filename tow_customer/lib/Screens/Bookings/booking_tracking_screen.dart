import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tow_customer/class/Booking.dart';
import 'package:tow_customer/class/Pet.dart';
import 'package:tow_customer/class/ServiceProvider.dart';
import 'package:tow_customer/constants.dart';
import 'package:tow_customer/Screens/Bookings/message_page.dart';
import 'package:intl/intl.dart';
import 'package:tow_customer/Screens/Home/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class BookingTrackingScreen extends StatefulWidget {
  final Booking booking;
  final Pet pet;
  final ServiceProvider serviceProvider;

  const BookingTrackingScreen(
      {Key? key,
      required this.booking,
      required this.pet,
      required this.serviceProvider})
      : super(key: key);

  @override
  _BookingTrackingScreenState createState() => _BookingTrackingScreenState();
}

class _BookingTrackingScreenState extends State<BookingTrackingScreen> {
  late GoogleMapController _mapController;

  // Location variables using real coordinates
  late LatLng _userLocation;
  late LatLng _storeLocation;
  late LatLng _driverLocation;

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
      isCompleted: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    TrackingStep(
      title: 'Pet Pickup',
      description: 'Pet picked up and journey started',
      isCompleted: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    TrackingStep(
      title: 'En Route to Destination',
      description: 'Traveling to the destination',
      isCompleted: true,
      timestamp: DateTime.now(),
    ),
    TrackingStep(
      title: 'Destination Reached',
      description: 'Pet safely delivered',
      isCompleted: false,
      timestamp: null,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize locations with real coordinates
    try {
      _userLocation =
          LatLng(double.parse(john.latitude), double.parse(john.longitude));
    } catch (e) {
      // Fallback if parsing fails
      _userLocation = const LatLng(4.3662, 100.9627);
    }

    // Get service provider location with fallback
    _storeLocation = widget.serviceProvider.coordinates ??
        const LatLng(
            4.5478, 101.0718); // Fallback for MizGroomers from sample data

    // Place driver at 70% of the way from store to user (for demo purposes)
    _driverLocation = LatLng(
      _storeLocation.latitude +
          (_userLocation.latitude - _storeLocation.latitude) * 0.7,
      _storeLocation.longitude +
          (_userLocation.longitude - _storeLocation.longitude) * 0.7,
    );
  }

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
        target: _driverLocation, // Center map on driver's current location
        zoom: 14,
      ),
      markers: {
        // User location marker (red)
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
        // Store location marker (green)
        Marker(
          markerId: const MarkerId('store_location'),
          position: _storeLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: widget.serviceProvider.name),
        ),
        // Driver location marker (blue)
        Marker(
          markerId: const MarkerId('driver_location'),
          position: _driverLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Driver Location'),
        ),
      },
      polylines: {
        // Polyline showing the route from driver to user
        Polyline(
          polylineId: const PolylineId('driver_to_user'),
          points: [_driverLocation, _userLocation],
          color: Colors.blue,
          width: 5,
        ),
        // Polyline showing the route already traveled
        Polyline(
          polylineId: const PolylineId('store_to_driver'),
          points: [_storeLocation, _driverLocation],
          color: Colors.grey,
          width: 5,
        ),
      },
      onMapCreated: (controller) {
        _mapController = controller;
      },
      // Enable gestures for map interaction
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      // Enable all map interactions
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
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
                    'https://static.vecteezy.com/system/resources/previews/035/814/962/large_2x/ai-generated-of-young-asian-engineer-man-handsome-smiling-in-orange-vest-factory-worker-ai-generated-free-photo.jpg',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sobri Hashim',
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
                IconButton(
                  icon: const Icon(Icons.message_rounded, color: kPrimaryColor),
                  onPressed: () {
                    // Implement messaging functionality
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagingScreen(
                          driverName: 'Sobri Hashim',
                          driverImage:
                              'https://static.vecteezy.com/system/resources/previews/035/814/962/large_2x/ai-generated-of-young-asian-engineer-man-handsome-smiling-in-orange-vest-factory-worker-ai-generated-free-photo.jpg',
                        ),
                      ),
                    );
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
