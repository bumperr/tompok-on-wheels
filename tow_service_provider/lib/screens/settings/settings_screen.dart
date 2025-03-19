import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSidebarOpen = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Settings'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          : null,
      drawer: isSmallScreen
          ? Drawer(
              child: SidebarMenu(
                currentRoute: AppRoutes.settingsRoute,
                onMenuItemSelected: () {
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar menu for large screens
          if (!isSmallScreen && _isSidebarOpen)
            SidebarMenu(currentRoute: AppRoutes.settingsRoute),

          // Toggle button for sidebar
          if (!isSmallScreen)
            InkWell(
              onTap: () {
                setState(() {
                  _isSidebarOpen = !_isSidebarOpen;
                });
              },
              child: Container(
                width: 24,
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    _isSidebarOpen ? Icons.chevron_left : Icons.chevron_right,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),

          // Main content area
          Expanded(
            child: Container(
              color: kBackgroundColor,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Settings categories
                    _buildSettingsCategories(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Profile
        _buildSettingsCategoryCard(
          icon: Icons.business,
          title: 'Business Profile',
          description:
              'Manage your business information, operating hours, and service location',
          items: [
            _buildSettingsItem(
              icon: Icons.store,
              title: 'Business Information',
              subtitle:
                  'Update your business name, description, and contact details',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.profileSettingsRoute),
            ),
            _buildSettingsItem(
              icon: Icons.access_time,
              title: 'Operating Hours',
              subtitle: 'Set your business hours and availability',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.profileSettingsRoute),
            ),
            _buildSettingsItem(
              icon: Icons.location_on,
              title: 'Service Location',
              subtitle: 'Update your business address and service area',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.profileSettingsRoute),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Account Settings
        _buildSettingsCategoryCard(
          icon: Icons.person,
          title: 'Account Settings',
          description: 'Manage your account preferences and security settings',
          items: [
            _buildSettingsItem(
              icon: Icons.account_circle,
              title: 'Personal Information',
              subtitle: 'Update your name, email, and profile picture',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.userSettingsRoute),
            ),
            _buildSettingsItem(
              icon: Icons.lock,
              title: 'Password & Security',
              subtitle: 'Change your password and security options',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.userSettingsRoute),
            ),
            _buildSettingsItem(
              icon: Icons.notifications,
              title: 'Notification Preferences',
              subtitle: 'Customize when and how you receive notifications',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.userSettingsRoute),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // App Settings
        _buildSettingsCategoryCard(
          icon: Icons.settings,
          title: 'App Settings',
          description: 'Customize your application preferences',
          items: [
            _buildSettingsItem(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Change your preferred language',
              onTap: () => _showLanguageOptions(),
            ),
            _buildSettingsItem(
              icon: Icons.color_lens,
              title: 'Theme',
              subtitle: 'Choose between light and dark theme',
              onTap: () => _showThemeOptions(),
            ),
            _buildSettingsItem(
              icon: Icons.notifications_active,
              title: 'Push Notifications',
              subtitle: 'Enable or disable push notifications',
              onTap: () => _togglePushNotifications(),
              trailing: Switch(
                value: true, // Replace with actual state
                onChanged: (value) => _togglePushNotifications(),
                activeColor: kPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Support & Help
        _buildSettingsCategoryCard(
          icon: Icons.help,
          title: 'Support & Help',
          description: 'Get help and learn more about the app',
          items: [
            _buildSettingsItem(
              icon: Icons.help_center,
              title: 'Help Center',
              subtitle: 'View frequently asked questions and tutorials',
              onTap: () => _openHelpCenter(),
            ),
            _buildSettingsItem(
              icon: Icons.contact_support,
              title: 'Contact Support',
              subtitle: 'Get in touch with our support team',
              onTap: () => _contactSupport(),
            ),
            _buildSettingsItem(
              icon: Icons.policy,
              title: 'Terms & Privacy Policy',
              subtitle: 'View our terms of service and privacy policy',
              onTap: () => _viewTermsAndPolicy(),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Account Actions
        _buildSettingsCategoryCard(
          icon: Icons.logout,
          title: 'Account Actions',
          description: 'Logout or manage your account status',
          items: [
            _buildSettingsItem(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out from your account',
              onTap: () => _confirmLogout(),
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsCategoryCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Widget> items,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: kPrimaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? Colors.grey.shade700).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color ?? Colors.grey.shade700,
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
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
          ],
        ),
      ),
    );
  }

  // Helper methods for settings actions
  void _showLanguageOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English', 'en', true),
              _buildLanguageOption('Bahasa Melayu', 'ms', false),
              _buildLanguageOption('中文', 'zh', false),
              _buildLanguageOption('Tamil', 'ta', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, String code, bool isSelected) {
    return ListTile(
      title: Text(language),
      leading: isSelected
          ? Icon(Icons.radio_button_checked, color: kPrimaryColor)
          : const Icon(Icons.radio_button_unchecked),
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language changed to $language')),
        );
      },
    );
  }

  void _showThemeOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption('Light Theme', true),
              _buildThemeOption('Dark Theme', false),
              _buildThemeOption('System Default', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(String theme, bool isSelected) {
    return ListTile(
      title: Text(theme),
      leading: isSelected
          ? Icon(Icons.radio_button_checked, color: kPrimaryColor)
          : const Icon(Icons.radio_button_unchecked),
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Theme changed to $theme')),
        );
      },
    );
  }

  void _togglePushNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Push notifications toggled')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Help center functionality not implemented yet')),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Contact support functionality not implemented yet')),
    );
  }

  void _viewTermsAndPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Terms and policy functionality not implemented yet')),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.loginRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
