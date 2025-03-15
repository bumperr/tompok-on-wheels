
// lib/screens/home/components/earnings_summary.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';

class EarningsSummary extends StatelessWidget {
  final double todayEarnings;
  final double weeklyEarnings;
  final int tripsCompleted;

  const EarningsSummary({
    Key? key,
    required this.todayEarnings,
    required this.weeklyEarnings,
    required this.tripsCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
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
          const Text(
            "Earnings Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEarningsItem(
                title: "Today",
                amount: todayEarnings,
                icon: Icons.today,
              ),
              _buildEarningsItem(
                title: "This Week",
                amount: weeklyEarnings,
                icon: Icons.date_range,
              ),
              _buildEarningsItem(
                title: "Trips",
                value: "$tripsCompleted",
                icon: Icons.directions_car,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsItem({
    required String title,
    double? amount,
    String? value,
    required IconData icon,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount != null ? "RM ${amount.toStringAsFixed(2)}" : value!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
