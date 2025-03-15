
// lib/screens/profile/components/document_section.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';
import 'package:image_picker/image_picker.dart';

class DocumentSection extends StatelessWidget {
  final bool isEditing;
  
  const DocumentSection({
    Key? key,
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
            const Text(
              'Documents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDocumentItem(
              context,
              title: 'Driver License',
              status: 'Verified',
              expiryDate: '10/25/2026',
              isVerified: true,
              isEditing: isEditing,
            ),
            _buildDocumentItem(
              context,
              title: 'Vehicle Registration',
              status: 'Verified',
              expiryDate: '03/15/2025',
              isVerified: true,
              isEditing: isEditing,
            ),
            _buildDocumentItem(
              context,
              title: 'Insurance Certificate',
              status: 'Verified',
              expiryDate: '06/30/2025',
              isVerified: true,
              isEditing: isEditing,
            ),
            _buildDocumentItem(
              context,
              title: 'Pet Transportation Certification',
              status: 'Pending Verification',
              expiryDate: '11/12/2026',
              isVerified: false,
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(
    BuildContext context, {
    required String title,
    required String status,
    required String expiryDate,
    required bool isVerified,
    required bool isEditing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.insert_drive_file,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isVerified ? Icons.verified : Icons.pending,
                      color: isVerified ? Colors.green : Colors.orange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: isVerified ? Colors.green : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Expiry: $expiryDate',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.file_upload, color: kPrimaryColor),
              onPressed: () {
                _showDocumentUploadOptions(context);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.visibility, color: kPrimaryColor),
              onPressed: () {
                // View document
              },
            ),
        ],
      ),
    );
  }

  void _showDocumentUploadOptions(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _picker.pickImage(source: ImageSource.camera);
                  // In a real app, you would then upload this image
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document uploaded successfully')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _picker.pickImage(source: ImageSource.gallery);
                  // In a real app, you would then upload this image
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document uploaded successfully')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_present),
                title: const Text('Upload document file'),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, you would open a file picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document uploaded successfully')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}