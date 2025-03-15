// lib/screens/trip_details/trip_details_screen.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/class/trip.dart';
import 'package:tow_driver/class/pet_checklist.dart';
import 'package:tow_driver/constants.dart';
import 'package:tow_driver/screens/trip_details/components/trip_map_view.dart';
import 'package:tow_driver/screens/trip_details/components/pet_details_card.dart';
import 'package:tow_driver/screens/trip_details/components/trip_timeline.dart';
import 'package:tow_driver/screens/trip_details/components/customer_info_card.dart';
import 'package:tow_driver/screens/trip_details/components/checklist_card.dart';
import 'package:tow_driver/screens/messaging/messaging_screen.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip trip;
  final PetChecklist checklist;

  const TripDetailsScreen({
    Key? key,
    required this.trip,
    required this.checklist,
  }) : super(key: key);

  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late TripStatus _currentStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.trip.status;
  }

  void _updateTripStatus(TripStatus newStatus) {
    // In a real app, this would call an API to update the trip status
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _currentStatus = newStatus;
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trip status updated to ${_getStatusText(newStatus)}'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  String _getStatusText(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return 'Pending';
      case TripStatus.accepted:
        return 'Accepted';
      case TripStatus.enRouteToPickup:
        return 'En Route to Pickup';
      case TripStatus.arrived:
        return 'Arrived';
      case TripStatus.inProgress:
        return 'In Progress';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.cancelled:
        return 'Cancelled';
      // ignore: unreachable_switch_default
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Flexible app bar with map
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Trip Details',
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
              background: TripMapView(
                pickupLatLng: LatLng(
                  double.parse(widget.trip.pickupLatitude),
                  double.parse(widget.trip.pickupLongitude),
                ),
                destinationLatLng: LatLng(
                  double.parse(widget.trip.destinationLatitude),
                  double.parse(widget.trip.destinationLongitude),
                ),
                driverLatLng: LatLng(
                  // For demo purposes, place driver between pickup and destination
                  double.parse(widget.trip.pickupLatitude) +
                      (double.parse(widget.trip.destinationLatitude) -
                              double.parse(widget.trip.pickupLatitude)) *
                          0.4,
                  double.parse(widget.trip.pickupLongitude) +
                      (double.parse(widget.trip.destinationLongitude) -
                              double.parse(widget.trip.pickupLongitude)) *
                          0.4,
                ),
                tripStatus: _currentStatus,
              ),
            ),
            backgroundColor: kPrimaryColor,
          ),

          // Trip Status and Actions
          SliverToBoxAdapter(
            child: _buildActionPanel(),
          ),

          // Trip Timeline
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TripTimeline(
                status: _currentStatus,
              ),
            ),
          ),

          // Pet Details
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: PetDetailsCard(
                trip: widget.trip,
              ),
            ),
          ),

          // Customer Info
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomerInfoCard(
                trip: widget.trip,
                onMessageTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagingScreen(
                        customerId: widget.trip.customerId,
                        customerName: widget.trip.customerName,
                      ),
                    ),
                  );
                },
                onCallTap: () {
                  // In a real app, this would initiate a phone call
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling ${widget.trip.customerName}...'),
                    ),
                  );
                },
              ),
            ),
          ),

          // Checklists
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ChecklistCard(
                title: "Pickup Checklist",
                checklistItems: widget.checklist.pickupItems,
                onItemToggle: (id, value) {
                  setState(() {
                    final item = widget.checklist.pickupItems
                        .firstWhere((item) => item.id == id);
                    item.isCompleted = value;
                  });
                },
                isEnabled: _currentStatus == TripStatus.arrived ||
                    _currentStatus == TripStatus.enRouteToPickup,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ChecklistCard(
                title: "In Transit Checklist",
                checklistItems: widget.checklist.inProgressItems,
                onItemToggle: (id, value) {
                  setState(() {
                    final item = widget.checklist.inProgressItems
                        .firstWhere((item) => item.id == id);
                    item.isCompleted = value;
                  });
                },
                isEnabled: _currentStatus == TripStatus.inProgress,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ChecklistCard(
                title: "Dropoff Checklist",
                checklistItems: widget.checklist.dropoffItems,
                onItemToggle: (id, value) {
                  setState(() {
                    final item = widget.checklist.dropoffItems
                        .firstWhere((item) => item.id == id);
                    item.isCompleted = value;
                  });
                },
                isEnabled: _currentStatus == TripStatus.inProgress,
              ),
            ),
          ),

          // Emergency Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.emergency),
                label: const Text("Emergency Assistance"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kEmergencyColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Show emergency options
                  _showEmergencyDialog();
                },
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {
    // Define status flow and action buttons based on current status
    String actionButtonText = "";
    TripStatus? nextStatus;

    switch (_currentStatus) {
      case TripStatus.pending:
        actionButtonText = "Accept Trip";
        nextStatus = TripStatus.accepted;
        break;
      case TripStatus.accepted:
        actionButtonText = "Start Trip (En Route)";
        nextStatus = TripStatus.enRouteToPickup;
        break;
      case TripStatus.enRouteToPickup:
        actionButtonText = "Arrived at Pickup";
        nextStatus = TripStatus.arrived;
        break;
      case TripStatus.arrived:
        actionButtonText = "Start Journey";
        nextStatus = TripStatus.inProgress;
        break;
      case TripStatus.inProgress:
        actionButtonText = "Complete Trip";
        nextStatus = TripStatus.completed;
        break;
      case TripStatus.completed:
        actionButtonText = "Trip Completed";
        nextStatus = null; // No next status
        break;
      case TripStatus.cancelled:
        actionButtonText = "Trip Cancelled";
        nextStatus = null; // No next status
        break;
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip basic details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trip #${widget.trip.id.substring(4)}", // Show only last part of ID
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_currentStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(_currentStatus)),
                  ),
                  child: Text(
                    _getStatusText(_currentStatus),
                    style: TextStyle(
                      color: _getStatusColor(_currentStatus),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date and time
            Row(
              children: [
                const Icon(
                  Icons.event,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat("EEEE, MMMM d, y").format(widget.trip.date),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.trip.startTime.format(context),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Trip earnings
            Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Trip Earnings:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "RM ${widget.trip.driverEarnings.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action button
            if (nextStatus != null) // Only show button if there's a next status
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      _isLoading ? null : () => _updateTripStatus(nextStatus!),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          actionButtonText,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: null,
                  child: Text(
                    actionButtonText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Cancel button for active trips
            if (_currentStatus != TripStatus.completed &&
                _currentStatus != TripStatus.cancelled)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : () => _showCancelDialog(),
                    child: const Text(
                      "Cancel Trip",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return Colors.orange;
      case TripStatus.accepted:
        return Colors.blue;
      case TripStatus.enRouteToPickup:
        return Colors.purple;
      case TripStatus.arrived:
        return Colors.amber;
      case TripStatus.inProgress:
        return Colors.green;
      case TripStatus.completed:
        return Colors.teal;
      case TripStatus.cancelled:
        return Colors.red;
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Trip'),
        content: const Text(
          'Are you sure you want to cancel this trip? '
          'This action cannot be undone and may affect your ratings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _updateTripStatus(TripStatus.cancelled);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmergencyOption(
              icon: Icons.local_police,
              title: 'Call Police',
              subtitle: 'Emergency line: 999',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling police...'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
            _buildEmergencyOption(
              icon: Icons.healing,
              title: 'Medical Emergency',
              subtitle: 'Ambulance: 999',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling ambulance...'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
            _buildEmergencyOption(
              icon: Icons.support_agent,
              title: 'Contact Support',
              subtitle: 'TOW support hotline',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling TOW support...'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            _buildEmergencyOption(
              icon: Icons.pets,
              title: 'Veterinary Emergency',
              subtitle: 'Near 24-hour vet clinic',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling emergency vet...'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: kEmergencyColor.withOpacity(0.2),
        child: Icon(
          icon,
          color: kEmergencyColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
