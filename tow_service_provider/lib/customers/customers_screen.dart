import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({Key? key}) : super(key: key);

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails>
    with SingleTickerProviderStateMixin {
  bool _isSidebarOpen = true;
  bool _isLoading = true;
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample customer data
  final Map<String, dynamic> _customer = {
    'id': 'C001',
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+60123456789',
    'address': '123 Main Street, Kuala Lumpur',
    'imageUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
    'joinDate': DateTime(2022, 3, 15),
    'totalBookings': 8,
    'totalSpent': 680.00,
    'preferredPaymentMethod': 'Credit Card',
    'lastVisit': DateTime.now().subtract(const Duration(days: 5)),
    'notes': 'Prefers weekend appointments. Always arrives on time.',
    'pets': [
      {
        'id': 'P001',
        'name': 'Oyen',
        'type': 'Cat',
        'breed': 'Domestic Shorthair',
        'age': 3,
        'imageUrl':
            'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
      },
      {
        'id': 'P006',
        'name': 'Max',
        'type': 'Cat',
        'breed': 'Ragdoll',
        'age': 1,
        'imageUrl':
            'https://images.unsplash.com/photo-1494256997604-768d1f608cac',
      }
    ],
  };

  // Sample booking history
  final List<Map<String, dynamic>> _bookingHistory = [
    {
      'id': 'B001',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'service': 'Basic Grooming',
      'petName': 'Oyen',
      'status': 'Completed',
      'price': 80.0,
      'isPaid': true,
    },
    {
      'id': 'B002',
      'date': DateTime.now().subtract(const Duration(days: 35)),
      'service': 'Health Check-up',
      'petName': 'Oyen',
      'status': 'Completed',
      'price': 120.0,
      'isPaid': true,
    },
    {
      'id': 'B003',
      'date': DateTime.now().subtract(const Duration(days: 65)),
      'service': 'Basic Grooming',
      'petName': 'Max',
      'status': 'Completed',
      'price': 80.0,
      'isPaid': true,
    },
    {
      'id': 'B004',
      'date': DateTime.now().add(const Duration(days: 5)),
      'service': 'Premium Grooming',
      'petName': 'Oyen',
      'status': 'Confirmed',
      'price': 120.0,
      'isPaid': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    // Get customer ID from route arguments if available
    // ignore: unused_local_variable
    final customerId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'C001';

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: Text(_isLoading ? 'Customer Details' : _customer['name']),
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
                currentRoute: AppRoutes.customersRoute,
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
            SidebarMenu(currentRoute: AppRoutes.customersRoute),

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
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer profile header
                        _buildCustomerProfileHeader(),

                        // Tabs
                        _buildTabBar(),

                        // Tab content
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildOverviewTab(),
                              _buildBookingHistoryTab(),
                              _buildPetsTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),

          // Customer image
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(_customer['imageUrl']),
            onBackgroundImageError: (exception, stackTrace) {
              // Handle error loading image
            },
            child: _customer['imageUrl'].isEmpty
                ? Text(
                    _customer['name'].substring(0, 1),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 24),

          // Customer basic info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _customer['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Customer'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Edit customer functionality not implemented yet')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Customer since ${DateFormat('MMMM d, yyyy').format(_customer['joinDate'])}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.pets,
                      label: '${(_customer['pets'] as List).length} Pets',
                      color: kPetCardColor,
                    ),
                    const SizedBox(width: 16),
                    _buildInfoChip(
                      icon: Icons.calendar_month,
                      label: '${_customer['totalBookings']} Bookings',
                      color: kBookingCardColor,
                    ),
                    const SizedBox(width: 16),
                    _buildInfoChip(
                      icon: Icons.attach_money,
                      label: 'RM ${_customer['totalSpent'].toStringAsFixed(2)}',
                      color: kRevenueCardColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.call),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Calling ${_customer['name']}')),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.message),
                      label: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentColor,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatRoute,
                          arguments: _customer['id'],
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('New Booking'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'New booking functionality not implemented yet')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: kPrimaryColor,
        labelColor: kPrimaryColor,
        unselectedLabelColor: Colors.grey.shade700,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Booking History'),
          Tab(text: 'Pets'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactInfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: _customer['email'],
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfoRow(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: _customer['phone'],
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfoRow(
                    icon: Icons.location_on,
                    label: 'Address',
                    value: _customer['address'],
                  ),
                  const SizedBox(height: 12),
                  _buildContactInfoRow(
                    icon: Icons.payment,
                    label: 'Preferred Payment',
                    value: _customer['preferredPaymentMethod'],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Customer Stats
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Bookings',
                          value: _customer['totalBookings'].toString(),
                          icon: Icons.calendar_month,
                          color: kBookingCardColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Spent',
                          value:
                              'RM ${_customer['totalSpent'].toStringAsFixed(2)}',
                          icon: Icons.attach_money,
                          color: kRevenueCardColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Last Visit',
                          value: DateFormat('MMM d, yyyy')
                              .format(_customer['lastVisit']),
                          icon: Icons.access_time,
                          color: kAccentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Notes
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notes & Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Edit notes functionality not implemented yet')),
                          );
                        },
                        tooltip: 'Edit notes',
                        visualDensity: VisualDensity.compact,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_customer['notes'].isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _customer['notes'],
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Text(
                        'No notes available for this customer.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingHistoryTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking History (${_bookingHistory.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Create Booking'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Create booking functionality not implemented yet')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _bookingHistory.isEmpty
                ? _buildEmptyState(
                    icon: Icons.history,
                    message: 'No booking history found',
                  )
                : ListView.separated(
                    itemCount: _bookingHistory.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final booking = _bookingHistory[index];
                      return _buildBookingHistoryCard(booking);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsTab() {
    final pets = _customer['pets'] as List;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pets (${pets.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Pet'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Add pet functionality not implemented yet')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: pets.isEmpty
                ? _buildEmptyState(
                    icon: Icons.pets,
                    message: 'No pets found',
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return _buildPetCard(pet);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingHistoryCard(Map<String, dynamic> booking) {
    final statusColor = booking['status'] == 'Completed'
        ? kCompletedColor
        : booking['status'] == 'Confirmed'
            ? kConfirmedColor
            : booking['status'] == 'Cancelled'
                ? kCancelledColor
                : kPendingColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bookingDetailsRoute,
            arguments: booking['id'],
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date container
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('MMM').format(booking['date']),
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd').format(booking['date']),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          DateFormat('yyyy').format(booking['date']),
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Booking details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking['service'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            booking['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.pets,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking['petName'],
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price and actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RM ${booking['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking['isPaid'] ? 'Paid' : 'Unpaid',
                    style: TextStyle(
                      color: booking['isPaid'] ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.bookingDetailsRoute,
                        arguments: booking['id'],
                      );
                    },
                    tooltip: 'View details',
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.petDetailsRoute,
            arguments: pet['id'],
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet image
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  pet['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          Icons.pets,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Pet details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${pet['age']} yrs',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet['type']} • ${pet['breed']}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
