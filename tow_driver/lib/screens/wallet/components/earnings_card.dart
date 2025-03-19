import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';

class EarningsCard extends StatelessWidget {
  final double availableBalance;
  final double weeklyEarnings;
  final VoidCallback onWithdraw;

  const EarningsCard({
    Key? key,
    required this.availableBalance,
    required this.weeklyEarnings,
    required this.onWithdraw,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceSection(),
              const SizedBox(height: 3),
              _buildSummarySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Available Balance',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'RM ${availableBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12, // Reduced horizontal padding
              vertical: 8, // Reduced vertical padding
            ),
            minimumSize: const Size(0, 0), // Allow button to be smaller
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
          ),
          onPressed: onWithdraw,
          child: Text(
            'Withdraw',
            style: TextStyle(
              fontSize: 12, // Smaller font size
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildEarningsSummaryItem(
            title: 'This Week',
            value: 'RM ${weeklyEarnings.toStringAsFixed(2)}',
            icon: Icons.date_range,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildEarningsSummaryItem(
            title: 'Last Withdrawal',
            value: '5 days ago',
            icon: Icons.history,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsSummaryItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
}
