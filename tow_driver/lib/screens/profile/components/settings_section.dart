// lib/screens/profile/components/settings_section.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  _SettingsSectionState createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'English';

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
              'App Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive alerts for new booking requests and updates',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
            ),
            _buildSettingItem(
              icon: Icons.location_on,
              title: 'Location Services',
              subtitle: 'Allow app to access your location',
              trailing: Switch(
                value: _locationEnabled,
                onChanged: (value) {
                  setState(() {
                    _locationEnabled = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
            ),
            _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Switch between light and dark theme',
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
                activeColor: kPrimaryColor,
              ),
            ),
            _buildSettingItem(
              icon: Icons.language,
              title: 'Language',
              subtitle: _language,
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  _showLanguageSelectionDialog();
                },
              ),
            ),
            _buildSettingItem(
              icon: Icons.help,
              title: 'Help Center',
              subtitle: 'FAQ and support resources',
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  // Navigate to help center
                },
              ),
            ),
            _buildSettingItem(
              icon: Icons.shield,
              title: 'Privacy & Terms',
              subtitle: 'Privacy policy and terms of service',
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  // Navigate to privacy and terms
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: kPrimaryColor.withOpacity(0.1),
            child: Icon(
              icon,
              color: kPrimaryColor,
              size: 20,
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
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: [
          _buildLanguageOption('English'),
          _buildLanguageOption('Bahasa Malaysia'),
          _buildLanguageOption('中文 (Chinese)'),
          _buildLanguageOption('Tamil (தமிழ்)'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _language = language;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              language,
              style: TextStyle(
                fontWeight:
                    _language == language ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_language == language)
              const Icon(
                Icons.check,
                color: kPrimaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
