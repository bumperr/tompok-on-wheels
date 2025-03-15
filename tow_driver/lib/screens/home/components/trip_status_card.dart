// lib/screens/home/components/trip_status_card.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';
import 'package:tow_driver/class/trip.dart';
//import 'package:intl/intl.dart';

class TripStatusCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onViewDetails;

  const TripStatusCard({
    Key? key,
    required this.trip,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Current Trip",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusChip(trip.status),
            ],
          ),
          const SizedBox(height: 16),

          // Pet Details with image
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
                      "${trip.petBreed} • ${trip.petAge} years",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Route Info
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pickup",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      trip.pickupAddress,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Vertical connector line
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: SizedBox(
              height: 20,
              child: VerticalDivider(
                color: Colors.grey[400],
                thickness: 2,
                width: 20,
              ),
            ),
          ),

          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Destination",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      trip.destinationAddress,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Trip Info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTripInfoItem(
                icon: Icons.route,
                value: "${trip.distance.toStringAsFixed(1)} km",
              ),
              _buildTripInfoItem(
                icon: Icons.access_time,
                value: "${trip.duration.toInt()} min",
              ),
              _buildTripInfoItem(
                icon: Icons.monetization_on,
                value: "RM ${trip.driverEarnings.toStringAsFixed(2)}",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // View Details Button
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
              onPressed: onViewDetails,
              child: const Text(
                "View Details",
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

  Widget _buildTripInfoItem({
    required IconData icon,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
