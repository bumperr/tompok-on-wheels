import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
//import 'package:intl/intl.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  bool _isEditing = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Sample business profile data
  final Map<String, dynamic> _businessProfile = {
    'name': 'Pet Paradise',
    'category': 'Grooming',
    'description':
        'We provide premium grooming and care services for pets in the Kuala Lumpur area, specializing in cats and small animals.',
    'email': 'contact@petparadise.com',
    'phone': '+60123456789',
    'website': 'www.petparadise.com',
    'address': '123 Jalan Sultan Ismail, Kuala Lumpur, 50250',
    'isVerified': true,
    'rating': 4.8,
    'reviewCount': 156,
    'joinDate': DateTime(2022, 1, 15),
    'logoUrl': 'https://example.com/logo.png',
    'bannerUrl': 'https://example.com/banner.jpg',
    'businessHours': [
      {
        'day': 'Monday',
        'openTime': '09:00',
        'closeTime': '18:00',
        'isOpen': true
      },
      {
        'day': 'Tuesday',
        'openTime': '09:00',
        'closeTime': '18:00',
        'isOpen': true
      },
      {
        'day': 'Wednesday',
        'openTime': '09:00',
        'closeTime': '18:00',
        'isOpen': true
      },
      {
        'day': 'Thursday',
        'openTime': '09:00',
        'closeTime': '18:00',
        'isOpen': true
      },
      {
        'day': 'Friday',
        'openTime': '09:00',
        'closeTime': '18:00',
        'isOpen': true
      },
      {
        'day': 'Saturday',
        'openTime': '10:00',
        'closeTime': '16:00',
        'isOpen': true
      },
      {
        'day': 'Sunday',
        'openTime': '10:00',
        'closeTime': '14:00',
        'isOpen': false
      },
    ],
    'amenities': [
      'Free Wifi',
      'Parking Available',
      'Pet-Friendly Waiting Area'
    ],
    'paymentMethods': ['Cash', 'Credit Card', 'Online Banking'],
    'serviceCategories': ['Grooming', 'Boarding', 'Veterinary'],
    'capacityPerDay': 15,
    'notes':
        'Specializing in short-haired and long-haired breeds with sensitive skin.',
  };

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;
  late TextEditingController _capacityController;

  // Editable business hours
  late List<Map<String, dynamic>> _editableBusinessHours;

  // Editable lists
  late List<String> _editableAmenities;
  late List<String> _editablePaymentMethods;
  late List<String> _editableServiceCategories;
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current values
    _nameController = TextEditingController(text: _businessProfile['name']);
    _descriptionController =
        TextEditingController(text: _businessProfile['description']);
    _emailController = TextEditingController(text: _businessProfile['email']);
    _phoneController = TextEditingController(text: _businessProfile['phone']);
    _websiteController =
        TextEditingController(text: _businessProfile['website']);
    _addressController =
        TextEditingController(text: _businessProfile['address']);
    _notesController = TextEditingController(text: _businessProfile['notes']);
    _capacityController = TextEditingController(
        text: _businessProfile['capacityPerDay'].toString());

    // Create editable copies of lists
    _editableBusinessHours =
        List<Map<String, dynamic>>.from(_businessProfile['businessHours']);
    _editableAmenities = List<String>.from(_businessProfile['amenities']);
    _editablePaymentMethods =
        List<String>.from(_businessProfile['paymentMethods']);
    _editableServiceCategories =
        List<String>.from(_businessProfile['serviceCategories']);
    _selectedCategory = _businessProfile['category'];
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _capacityController.dispose();
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
              title: const Text('Business Profile'),
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
                currentRoute: AppRoutes.profileSettingsRoute,
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
            SidebarMenu(currentRoute: AppRoutes.profileSettingsRoute),

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
                          // Header with title and action buttons
                          _buildHeader(),
                          const SizedBox(height: 24),

                          // Business profile form
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Basic information
                                _buildBasicInfoSection(),
                                const SizedBox(height: 24),

                                // Business hours
                                _buildBusinessHoursSection(),
                                const SizedBox(height: 24),

                                // Additional information
                                _buildAdditionalInfoSection(),
                                const SizedBox(height: 24),

                                // Action buttons
                                if (_isEditing) _buildActionButtons(),
                              ],
                            ),
                          ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage your business information and settings',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        _isEditing
            ? Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
                    onPressed: _saveChanges,
                  ),
                ],
              )
            : ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
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
                    Icons.business,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Business Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Business logo and banner
            _buildMediaSection(),
            const SizedBox(height: 24),

            // Basic info form fields
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Business Name',
                        hint: 'Enter your business name',
                        icon: Icons.store,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a business name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        label: 'Business Category',
                        icon: Icons.category,
                        value: _selectedCategory,
                        enabled: _isEditing,
                        items: kServiceCategories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: _isEditing
                            ? (value) {
                                setState(() {
                                  _selectedCategory = value.toString();
                                });
                              }
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Business Email',
                        hint: 'Enter business email',
                        icon: Icons.email,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Right column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Business Phone',
                        hint: 'Enter business phone',
                        icon: Icons.phone,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _websiteController,
                        label: 'Website (Optional)',
                        hint: 'Enter website URL',
                        icon: Icons.language,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _capacityController,
                        label: 'Daily Capacity',
                        hint: 'Max number of pets per day',
                        icon: Icons.pets,
                        enabled: _isEditing,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter capacity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Address
            _buildTextField(
              controller: _addressController,
              label: 'Business Address',
              hint: 'Enter your full business address',
              icon: Icons.location_on,
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _descriptionController,
              label: 'Business Description',
              hint: 'Describe your business and services',
              icon: Icons.description,
              enabled: _isEditing,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Notes
            _buildTextField(
              controller: _notesController,
              label: 'Additional Notes (Optional)',
              hint: 'Any additional information about your business',
              icon: Icons.notes,
              enabled: _isEditing,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Row(
      children: [
        // Logo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Business Logo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.store,
                        size: 48,
                        color: Colors.grey.shade500,
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () {
                                // Handle logo upload
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Logo upload functionality not implemented yet'),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // Banner
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Banner Image',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey.shade500,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () {
                              // Handle banner upload
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Banner upload functionality not implemented yet'),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessHoursSection() {
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
                        Icons.access_time,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Business Hours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (_isEditing)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset to Default'),
                    onPressed: () {
                      // Reset business hours to default
                      setState(() {
                        _editableBusinessHours = [
                          {
                            'day': 'Monday',
                            'openTime': '09:00',
                            'closeTime': '18:00',
                            'isOpen': true
                          },
                          {
                            'day': 'Tuesday',
                            'openTime': '09:00',
                            'closeTime': '18:00',
                            'isOpen': true
                          },
                          {
                            'day': 'Wednesday',
                            'openTime': '09:00',
                            'closeTime': '18:00',
                            'isOpen': true
                          },
                          {
                            'day': 'Thursday',
                            'openTime': '09:00',
                            'closeTime': '18:00',
                            'isOpen': true
                          },
                          {
                            'day': 'Friday',
                            'openTime': '09:00',
                            'closeTime': '18:00',
                            'isOpen': true
                          },
                          {
                            'day': 'Saturday',
                            'openTime': '10:00',
                            'closeTime': '16:00',
                            'isOpen': true
                          },
                          {
                            'day': 'Sunday',
                            'openTime': 'Closed',
                            'closeTime': 'Closed',
                            'isOpen': false
                          },
                        ];
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Business hours table
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1),
              },
              border: TableBorder.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
              children: [
                // Header row
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  children: [
                    _buildTableCell('Day', isHeader: true),
                    _buildTableCell('Open Time', isHeader: true),
                    _buildTableCell('Close Time', isHeader: true),
                    _buildTableCell('Status', isHeader: true),
                  ],
                ),
                // Day rows
                ..._editableBusinessHours.map((hours) {
                  return TableRow(
                    children: [
                      _buildTableCell(hours['day']),
                      _buildTableCell(
                        hours['isOpen'] ? hours['openTime'] : 'Closed',
                        isEditable: _isEditing && hours['isOpen'],
                        onTap: _isEditing && hours['isOpen']
                            ? () => _showTimePickerDialog(
                                hours, 'openTime', context)
                            : null,
                      ),
                      _buildTableCell(
                        hours['isOpen'] ? hours['closeTime'] : 'Closed',
                        isEditable: _isEditing && hours['isOpen'],
                        onTap: _isEditing && hours['isOpen']
                            ? () => _showTimePickerDialog(
                                hours, 'closeTime', context)
                            : null,
                      ),
                      _buildTableCell(
                        '',
                        customWidget: _isEditing
                            ? Switch(
                                value: hours['isOpen'],
                                onChanged: (value) {
                                  setState(() {
                                    hours['isOpen'] = value;
                                  });
                                },
                                activeColor: kPrimaryColor,
                              )
                            : Text(
                                hours['isOpen'] ? 'Open' : 'Closed',
                                style: TextStyle(
                                  color: hours['isOpen']
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
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
                    Icons.info,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Service categories
            _buildChipSection(
              title: 'Service Categories',
              icon: Icons.spa,
              items: _editableServiceCategories,
              onAdd: _isEditing
                  ? () => _showAddItemDialog('Add Service Category',
                      'Enter a service category', _editableServiceCategories)
                  : null,
              onDelete: _isEditing
                  ? (index) {
                      setState(() {
                        _editableServiceCategories.removeAt(index);
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 24),

            // Amenities
            _buildChipSection(
              title: 'Amenities',
              icon: Icons.local_cafe,
              items: _editableAmenities,
              onAdd: _isEditing
                  ? () => _showAddItemDialog(
                      'Add Amenity', 'Enter an amenity', _editableAmenities)
                  : null,
              onDelete: _isEditing
                  ? (index) {
                      setState(() {
                        _editableAmenities.removeAt(index);
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 24),

            // Payment methods
            _buildChipSection(
              title: 'Payment Methods',
              icon: Icons.payment,
              items: _editablePaymentMethods,
              onAdd: _isEditing
                  ? () => _showAddItemDialog('Add Payment Method',
                      'Enter a payment method', _editablePaymentMethods)
                  : null,
              onDelete: _isEditing
                  ? (index) {
                      setState(() {
                        _editablePaymentMethods.removeAt(index);
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
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
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

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    Function(dynamic)? onChanged,
    bool enabled = true,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          isDense: true,
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    bool isEditable = false,
    VoidCallback? onTap,
    Widget? customWidget,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: customWidget ??
            (isEditable
                ? InkWell(
                    onTap: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            fontWeight:
                                isHeader ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const Icon(
                          Icons.edit,
                          size: 16,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: isHeader ? TextAlign.center : TextAlign.start,
                  )),
      ),
    );
  }

  Widget _buildChipSection({
    required String title,
    required IconData icon,
    required List<String> items,
    VoidCallback? onAdd,
    Function(int)? onDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (onAdd != null)
              TextButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                onPressed: onAdd,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Chip(
              label: Text(item),
              backgroundColor: Colors.grey.shade100,
              deleteIcon:
                  onDelete != null ? const Icon(Icons.close, size: 16) : null,
              onDeleted: onDelete != null ? () => onDelete(index) : null,
            );
          }).toList(),
        ),
        if (items.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No items added yet',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showTimePickerDialog(
    Map<String, dynamic> hours,
    String field,
    BuildContext context,
  ) {
    final initialTime = _parseTimeString(hours[field]);

    showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    ).then((timeOfDay) {
      if (timeOfDay != null) {
        setState(() {
          hours[field] = _formatTimeOfDay(timeOfDay);
        });
      }
    });
  }

  TimeOfDay _parseTimeString(String timeString) {
    if (timeString == 'Closed') {
      return const TimeOfDay(hour: 9, minute: 0);
    }

    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showAddItemDialog(
    String title,
    String hint,
    List<String> items,
  ) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    items.add(text);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            setState(() {
              _isEditing = false;

              // Reset form controllers to original values
              _nameController.text = _businessProfile['name'];
              _descriptionController.text = _businessProfile['description'];
              _emailController.text = _businessProfile['email'];
              _phoneController.text = _businessProfile['phone'];
              _websiteController.text = _businessProfile['website'];
              _addressController.text = _businessProfile['address'];
              _notesController.text = _businessProfile['notes'];
              _capacityController.text =
                  _businessProfile['capacityPerDay'].toString();

              // Reset editable lists
              _editableBusinessHours = List<Map<String, dynamic>>.from(
                  _businessProfile['businessHours']);
              _editableAmenities =
                  List<String>.from(_businessProfile['amenities']);
              _editablePaymentMethods =
                  List<String>.from(_businessProfile['paymentMethods']);
              _editableServiceCategories =
                  List<String>.from(_businessProfile['serviceCategories']);
              _selectedCategory = _businessProfile['category'];
            });
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Save Changes'),
          onPressed: _saveChanges,
        ),
      ],
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });

      // Simulate saving to backend
      Future.delayed(const Duration(seconds: 1), () {
        // Update business profile with new values
        setState(() {
          _businessProfile['name'] = _nameController.text;
          _businessProfile['description'] = _descriptionController.text;
          _businessProfile['email'] = _emailController.text;
          _businessProfile['phone'] = _phoneController.text;
          _businessProfile['website'] = _websiteController.text;
          _businessProfile['address'] = _addressController.text;
          _businessProfile['notes'] = _notesController.text;
          _businessProfile['capacityPerDay'] =
              int.parse(_capacityController.text);
          _businessProfile['category'] = _selectedCategory;
          _businessProfile['businessHours'] = _editableBusinessHours;
          _businessProfile['amenities'] = _editableAmenities;
          _businessProfile['paymentMethods'] = _editablePaymentMethods;
          _businessProfile['serviceCategories'] = _editableServiceCategories;

          _isLoading = false;
          _isEditing = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }
}
