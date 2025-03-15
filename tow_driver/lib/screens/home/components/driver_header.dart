// lib/screens/home/components/driver_header.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';
import 'package:tow_driver/class/driver.dart';

class DriverHeader extends StatelessWidget {
  final Driver driver;
  final bool isOnline;
  final VoidCallback onToggleStatus;

  const DriverHeader({
    Key? key,
    required this.driver,
    required this.isOnline,
    required this.onToggleStatus,
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
      child: Row(
        children: [
          // Driver Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(driver.imageUrl),
          ),
          const SizedBox(width: 16),
          
          // Driver Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${driver.name}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${driver.rating}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.route,
                      color: kPrimaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${driver.completedTrips} trips",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Online/Offline Switch
          Switch(
            value: isOnline,
            onChanged: (value) => onToggleStatus(),
            activeColor: kActiveColor,
            activeTrackColor: kActiveColor.withOpacity(0.5),
            inactiveThumbColor: kInactiveColor,
            inactiveTrackColor: kInactiveColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}


