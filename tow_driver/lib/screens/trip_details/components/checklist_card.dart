
// lib/screens/trip_details/components/checklist_card.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/class/pet_checklist.dart';
import 'package:tow_driver/constants.dart';

class ChecklistCard extends StatelessWidget {
  final String title;
  final List<ChecklistItem> checklistItems;
  final Function(String, bool) onItemToggle;
  final bool isEnabled;

  const ChecklistCard({
    Key? key,
    required this.title,
    required this.checklistItems,
    required this.onItemToggle,
    this.isEnabled = true,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display completion count
                Text(
                  "${checklistItems.where((item) => item.isCompleted).length}/${checklistItems.length} completed",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...checklistItems.map((item) => _buildChecklistItem(item)),
            // If disabled, show overlay
            if (!isEnabled)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "This checklist will be available at the appropriate stage of the trip.",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(ChecklistItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: item.isCompleted,
            onChanged: isEnabled ? (bool? value) {
              if (value != null) {
                onItemToggle(item.id, value);
              }
            } : null,
            activeColor: kPrimaryColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    color: item.isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
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