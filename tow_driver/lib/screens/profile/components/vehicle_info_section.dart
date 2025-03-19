// lib/screens/profile/components/vehicle_info_section.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';
import 'package:tow_driver/class/driver.dart';

class VehicleInfoSection extends StatelessWidget {
  final Driver driver;
  final bool isEditing;

  const VehicleInfoSection({
    Key? key,
    required this.driver,
    required this.isEditing,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vehicle Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isEditing)
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    onPressed: () {
                      // Show edit vehicle dialog
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://img.rnudah.com/grids/29/2921082678327195655.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildVehicleInfoItem(
              label: 'Vehicle Type',
              value: driver.vehicleType,
              icon: Icons.directions_car,
            ),
            _buildVehicleInfoItem(
              label: 'Model',
              value: driver.vehicleModel,
              icon: Icons.car_repair,
            ),
            _buildVehicleInfoItem(
              label: 'License Plate',
              value: driver.licensePlate,
              icon: Icons.confirmation_number,
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Vehicle Features for Pet Transportation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Climate Control for Pet Comfort'),
            _buildFeatureItem('Non-Slip Flooring'),
            _buildFeatureItem('Secure Carrier Anchoring System'),
            _buildFeatureItem('First Aid Kit for Pets'),
            _buildFeatureItem('Proper Ventilation System'),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: kPrimaryColor,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(feature),
        ],
      ),
    );
  }
}
