import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
//import 'dart:io';
import 'package:intl/intl.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  bool _isEditingProfile = false;
  bool _isEditingPassword = false;
  bool _isEditingNotifications = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  // Sample user data
  final Map<String, dynamic> _userData = {
    'id': 'user123',
    'name': 'Alex Wong',
    'email': 'alex.wong@example.com',
    'phone': '+60123456789',
    'role': 'Admin',
    'imageUrl': '',
    'joinDate': DateTime(2022, 1, 15),
    'lastLoginDate': DateTime.now().subtract(const Duration(hours: 3)),
  };

  // Notification settings
  bool _emailBookingNotifications = true;
  bool _emailMarketingNotifications = false;
  bool _pushNewBookings = true;
  bool _pushBookingUpdates = true;
  bool _pushMessages = true;
  bool _pushReminders = true;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current values
    _nameController = TextEditingController(text: _userData['name']);
    _emailController = TextEditingController(text: _userData['email']);
    _phoneController = TextEditingController(text: _userData['phone']);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Account Settings'),
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
                currentRoute: AppRoutes.userSettingsRoute,
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
            SidebarMenu(currentRoute: AppRoutes.userSettingsRoute),

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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with title
                          _buildHeader(),
                          const SizedBox(height: 24),

                          // User profile section
                          _buildProfileSection(),
                          const SizedBox(height: 24),

                          // Password section
                          _buildPasswordSection(),
                          const SizedBox(height: 24),

                          // Notification settings section
                          _buildNotificationSection(),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Manage your personal information and preferences',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Icons.person,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _isEditingProfile
                    ? Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isEditingProfile = false;
                                // Reset form controllers
                                _nameController.text = _userData['name'];
                                _emailController.text = _userData['email'];
                                _phoneController.text = _userData['phone'];
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                            onPressed: _saveProfileChanges,
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        onPressed: () {
                          setState(() {
                            _isEditingProfile = true;
                          });
                        },
                      ),
              ],
            ),
            const SizedBox(height: 24),

            // Profile picture
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _userData['imageUrl'].isNotEmpty
                        ? NetworkImage(_userData['imageUrl'])
                        : null,
                    child: _userData['imageUrl'].isEmpty
                        ? Text(
                            _userData['name'].substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  if (_isEditingProfile)
                    TextButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Change Profile Picture'),
                      onPressed: () {
                        // Handle profile picture upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Profile picture upload functionality not implemented yet'),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile form
            Form(
              key: _profileFormKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                    enabled: _isEditingProfile,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'Enter your email address',
                    icon: Icons.email_outlined,
                    enabled: _isEditingProfile,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    icon: Icons.phone_outlined,
                    enabled: _isEditingProfile,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Additional profile information
            if (!_isEditingProfile) ...[
              const Divider(),
              const SizedBox(height: 16),
              _buildInfoRow('User ID', _userData['id']),
              const SizedBox(height: 8),
              _buildInfoRow('Role', _userData['role']),
              const SizedBox(height: 8),
              _buildInfoRow(
                'Member Since',
                DateFormat('MMMM d, yyyy').format(_userData['joinDate']),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                'Last Login',
                DateFormat('MMMM d, yyyy - h:mm a')
                    .format(_userData['lastLoginDate']),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Icons.lock_outline,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Password & Security',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _isEditingPassword
                    ? Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isEditingPassword = false;
                                // Clear password fields
                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Update'),
                            onPressed: _updatePassword,
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Change Password'),
                        onPressed: () {
                          setState(() {
                            _isEditingPassword = true;
                          });
                        },
                      ),
              ],
            ),
            const SizedBox(height: 24),

            // Password form
            if (_isEditingPassword)
              Form(
                key: _passwordFormKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _currentPasswordController,
                      label: 'Current Password',
                      hint: 'Enter your current password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _newPasswordController,
                      label: 'New Password',
                      hint: 'Enter your new password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm New Password',
                      hint: 'Confirm your new password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Password'),
                    subtitle: const Text('Last changed 30 days ago'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditingPassword = true;
                        });
                      },
                      child: const Text('Change'),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Two-Factor Authentication'),
                    subtitle: const Text('Not enabled'),
                    trailing: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('2FA functionality not implemented yet'),
                          ),
                        );
                      },
                      child: const Text('Enable'),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Icons.notifications_none,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _isEditingNotifications
                    ? Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isEditingNotifications = false;
                                // Reset notification settings
                                _emailBookingNotifications = true;
                                _emailMarketingNotifications = false;
                                _pushNewBookings = true;
                                _pushBookingUpdates = true;
                                _pushMessages = true;
                                _pushReminders = true;
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                            onPressed: _saveNotificationSettings,
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        onPressed: () {
                          setState(() {
                            _isEditingNotifications = true;
                          });
                        },
                      ),
              ],
            ),
            const SizedBox(height: 24),

            // Email notifications
            const Text(
              'Email Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              title: 'Booking Notifications',
              subtitle:
                  'Receive email notifications for new bookings, updates, and cancellations',
              value: _emailBookingNotifications,
              onChanged: _isEditingNotifications
                  ? (value) {
                      setState(() {
                        _emailBookingNotifications = value;
                      });
                    }
                  : null,
            ),
            _buildSwitchTile(
              title: 'Marketing & Promotional Emails',
              subtitle:
                  'Receive updates about new features, promotions, and news',
              value: _emailMarketingNotifications,
              onChanged: _isEditingNotifications
                  ? (value) {
                      setState(() {
                        _emailMarketingNotifications = value;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Push notifications
            const Text(
              'Push Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              title: 'New Bookings',
              subtitle: 'Get notified when you receive new bookings',
              value: _pushNewBookings,
              onChanged: _isEditingNotifications
                  ? (value) {
                      setState(() {
                        _pushNewBookings = value;
                      });
                    }
                  : null,
            ),
            _buildSwitchTile(
              title: 'Booking Updates',
              subtitle: 'Get notified when bookings are modified or cancelled',
              value: _pushBookingUpdates,
              onChanged: _isEditingNotifications
                  ? (value) {
                      setState(() {
                        _pushBookingUpdates = value;
                      });
                    }
                  : null,
            ),
            _buildSwitchTile(
              title: 'Messages',
              subtitle: 'Get notified when you receive new messages',
              value: _pushMessages,
              onChanged: _isEditingNotifications
                  ? (value) {
                      setState(() {
                        _pushMessages = value;
                      });
                    }
                  : null,
            ),
            _buildSwitchTile(
              title: 'Reminders',
              subtitle: 'Get reminders about upcoming appointments',
              value: _pushReminders,
              onChanged: _isEditingNotifications
                  ? (value) {
                      setState(() {
                        _pushReminders = value;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    Function(bool)? onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: kPrimaryColor,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _saveProfileChanges() {
    if (_profileFormKey.currentState!.validate()) {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        // Update user data
        setState(() {
          _userData['name'] = _nameController.text;
          _userData['email'] = _emailController.text;
          _userData['phone'] = _phoneController.text;
          _isLoading = false;
          _isEditingProfile = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  void _updatePassword() {
    if (_passwordFormKey.currentState!.validate()) {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        // Clear password fields
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        setState(() {
          _isLoading = false;
          _isEditingPassword = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  void _saveNotificationSettings() {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _isEditingNotifications = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification preferences updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
