
// lib/screens/profile/components/pet_safety_card.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';

class PetSafetyCard extends StatelessWidget {
  const PetSafetyCard({Key? key}) : super(key: key);

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
              'Pet Safety Training',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: const Icon(
                    Icons.pets,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pet Transportation Safety Certification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Completed on: October 15, 2024',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Text(
                          'Valid for 2 years',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Completed Modules',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildTrainingModule(
              title: 'Pet Handling Basics',
              progress: 1.0,
              completionDate: 'Sep 20, 2024',
            ),
            _buildTrainingModule(
              title: 'Stress Management in Animals',
              progress: 1.0,
              completionDate: 'Sep 25, 2024',
            ),
            _buildTrainingModule(
              title: 'Emergency Response',
              progress: 1.0,
              completionDate: 'Oct 5, 2024',
            ),
            _buildTrainingModule(
              title: 'Safe Transportation Techniques',
              progress: 1.0,
              completionDate: 'Oct 10, 2024',
            ),
            _buildTrainingModule(
              title: 'Pet First Aid',
              progress: 0.8,
              completionDate: 'In Progress',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.school),
                label: const Text('Continue Training'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryColor,
                  side: const BorderSide(color: kPrimaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  // Navigate to training portal
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingModule({
    required String title,
    required double progress,
    required String completionDate,
  }) {
    final isCompleted = progress >= 1.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                completionDate,
                style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? Colors.green : kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}