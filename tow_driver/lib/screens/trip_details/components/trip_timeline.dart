// lib/screens/trip_details/components/trip_timeline.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/class/trip.dart';
import 'package:tow_driver/constants.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TripTimeline extends StatelessWidget {
  final TripStatus status;

  const TripTimeline({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Trip Timeline",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimelineTile(
              title: "Trip Accepted",
              description: "You've accepted the trip request",
              isCompleted: _isStepCompleted(TripStatus.accepted),
              isFirst: true,
            ),
            _buildTimelineTile(
              title: "En Route to Pickup",
              description: "On the way to pickup location",
              isCompleted: _isStepCompleted(TripStatus.enRouteToPickup),
            ),
            _buildTimelineTile(
              title: "Arrived at Pickup",
              description: "Arrived at the pet's location",
              isCompleted: _isStepCompleted(TripStatus.arrived),
            ),
            _buildTimelineTile(
              title: "In Transit",
              description: "Transporting pet to destination",
              isCompleted: _isStepCompleted(TripStatus.inProgress),
            ),
            _buildTimelineTile(
              title: "Completed",
              description: "Trip successfully completed",
              isCompleted: _isStepCompleted(TripStatus.completed),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  bool _isStepCompleted(TripStatus step) {
    // Map the status priority
    final statusPriority = {
      TripStatus.pending: 0,
      TripStatus.accepted: 1,
      TripStatus.enRouteToPickup: 2,
      TripStatus.arrived: 3,
      TripStatus.inProgress: 4,
      TripStatus.completed: 5,
      TripStatus.cancelled: -1, // Special case
    };

    // If trip is cancelled, no steps are complete
    if (status == TripStatus.cancelled) {
      return false;
    }

    // Otherwise, compare priorities
    return statusPriority[status]! >= statusPriority[step]!;
  }

  Widget _buildTimelineTile({
    required String title,
    required String description,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.2,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        indicator: Container(
          decoration: BoxDecoration(
            color: isCompleted ? kPrimaryColor : Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? kPrimaryColor : Colors.grey,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: isCompleted ? Colors.white : Colors.grey[400],
            size: 16,
          ),
        ),
      ),
      beforeLineStyle: LineStyle(
        color: isCompleted ? kPrimaryColor : Colors.grey[300]!,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: isCompleted && !isLast ? kPrimaryColor : Colors.grey[300]!,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCompleted ? kPrimaryColor : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
