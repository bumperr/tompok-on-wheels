import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String imageUrl;
  final DateTime joinDate;
  final int totalBookings;
  final double totalSpent;
  final List<String> petIds;
  final List<String> petNames;
  final String lastService;
  final DateTime? lastServiceDate;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.imageUrl,
    required this.joinDate,
    required this.totalBookings,
    required this.totalSpent,
    required this.petIds,
    required this.petNames,
    required this.lastService,
    this.lastServiceDate,
  });
}

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  bool _isGridView = false;
  String _searchQuery = '';
  String _sortBy = 'Name';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample customers data
  final List<Customer> _customers = [
    Customer(
      id: 'C001',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+60123456789',
      address: '123 Main Street, Kuala Lumpur',
      imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      joinDate: DateTime(2022, 3, 15),
      totalBookings: 8,
      totalSpent: 680.00,
      petIds: ['P001', 'P006'],
      petNames: ['Oyen', 'Max'],
      lastService: 'Basic Grooming',
      lastServiceDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Customer(
      id: 'C002',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      phone: '+60123456790',
      address: '456 Park Avenue, Petaling Jaya',
      imageUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      joinDate: DateTime(2022, 5, 22),
      totalBookings: 5,
      totalSpent: 420.00,
      petIds: ['P002'],
      petNames: ['Tompok'],
      lastService: 'Health Check-up',
      lastServiceDate: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Customer(
      id: 'C003',
      name: 'Wei Lin',
      email: 'wei.lin@example.com',
      phone: '+60123456791',
      address: '789 Garden Road, Subang Jaya',
      imageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
      joinDate: DateTime(2022, 1, 10),
      totalBookings: 12,
      totalSpent: 950.00,
      petIds: ['P003'],
      petNames: ['Whiskers'],
      lastService: 'Premium Grooming',
      lastServiceDate: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Customer(
      id: 'C004',
      name: 'Sarah Johnson',
      email: 'sarah.j@example.com',
      phone: '+60123456792',
      address: '101 Lake View, Shah Alam',
      imageUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
      joinDate: DateTime(2022, 6, 5),
      totalBookings: 7,
      totalSpent: 580.00,
      petIds: ['P004'],
      petNames: ['Bella'],
      lastService: 'Basic Grooming',
      lastServiceDate: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Customer(
      id: 'C005',
      name: 'Ahmad Razali',
      email: 'ahmad.r@example.com',
      phone: '+60123456793',
      address: '202 Hill Street, Ampang',
      imageUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
      joinDate: DateTime(2022, 4, 18),
      totalBookings: 4,
      totalSpent: 350.00,
      petIds: ['P005'],
      petNames: ['Leo'],
      lastService: 'Boarding - Deluxe',
      lastServiceDate: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  // Filtered and sorted customers
  List<Customer> get filteredCustomers {
    List<Customer> result = _customers.where((customer) {
      // Filter by search query
      return customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.phone.contains(_searchQuery) ||
          customer.petNames.any((name) =>
              name.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();

    // Sort the results
    switch (_sortBy) {
      case 'Name':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Recent':
        result.sort((a, b) {
          if (a.lastServiceDate == null) return 1;
          if (b.lastServiceDate == null) return -1;
          return b.lastServiceDate!.compareTo(a.lastServiceDate!);
        });
        break;
      case 'Most Bookings':
        result.sort((a, b) => b.totalBookings.compareTo(a.totalBookings));
        break;
      case 'Highest Spend':
        result.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Customers'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.person_add),
        onPressed: () {
          // Add new customer
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Add customer functionality not implemented yet')),
          );
        },
      ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with actions
                  _buildHeader(),

                  // Filter and search row
                  _buildFilterRow(),

                  // Customers grid or list
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _isGridView
                            ? _buildCustomersGrid()
                            : _buildCustomersList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customers',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_customers.length} total customers',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
                tooltip: _isGridView ? 'List View' : 'Grid View',
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Add Customer'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Add customer functionality not implemented yet')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      color: Colors.white,
      child: Row(
        children: [
          // Search field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search customers or pets...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),

          // Sort by dropdown
          DropdownButton<String>(
            value: _sortBy,
            items: ['Name', 'Recent', 'Most Bookings', 'Highest Spend']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
            },
            hint: const Text('Sort By'),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersGrid() {
    if (filteredCustomers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No customers found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // Calculate responsive grid
    int crossAxisCount = 3;
    if (MediaQuery.of(context).size.width < 1200) crossAxisCount = 2;
    if (MediaQuery.of(context).size.width < 800) crossAxisCount = 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: filteredCustomers.length,
        itemBuilder: (context, index) {
          final customer = filteredCustomers[index];
          return _buildCustomerCard(customer);
        },
      ),
    );
  }

  Widget _buildCustomersList() {
    if (filteredCustomers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No customers found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView.separated(
        itemCount: filteredCustomers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final customer = filteredCustomers[index];
          return _buildCustomerListItem(customer);
        },
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.customerDetailsRoute,
            arguments: customer.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Customer avatar
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(customer.imageUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error loading image
                },
                child: customer.imageUrl.isEmpty
                    ? Text(
                        customer.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 16),

              // Customer name
              Text(
                customer.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Customer email
              Text(
                customer.email,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Customer phone
              Text(
                customer.phone,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Pets
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.pets,
                    size: 16,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pets: ${customer.petNames.join(", ")}',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Total spent
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.attach_money,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Total: RM ${customer.totalSpent.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${customer.name}')),
                      );
                    },
                    tooltip: 'Call customer',
                    color: kPrimaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.chatRoute,
                        arguments: customer.id,
                      );
                    },
                    tooltip: 'Message customer',
                    color: kPrimaryColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Create booking functionality not implemented yet')),
                      );
                    },
                    tooltip: 'Create booking',
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

  Widget _buildCustomerListItem(Customer customer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.customerDetailsRoute,
            arguments: customer.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer avatar
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(customer.imageUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error loading image
                },
                child: customer.imageUrl.isEmpty
                    ? Text(
                        customer.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Customer details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.email,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.phone,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pets
                    Row(
                      children: [
                        Icon(
                          Icons.pets,
                          size: 16,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Pets: ${customer.petNames.join(", ")}',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Stats and actions
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Customer since
                    Text(
                      'Customer since ${DateFormat('MMM yyyy').format(customer.joinDate)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Total bookings
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${customer.totalBookings} bookings',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Total spent
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 14,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'RM ${customer.totalSpent.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Last service
                    if (customer.lastServiceDate != null) ...[
                      Text(
                        'Last service: ${customer.lastService}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        DateFormat('MMM d, yyyy')
                            .format(customer.lastServiceDate!),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Calling ${customer.name}')),
                            );
                          },
                          tooltip: 'Call customer',
                          color: kPrimaryColor,
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.chatRoute,
                              arguments: customer.id,
                            );
                          },
                          tooltip: 'Message customer',
                          color: kPrimaryColor,
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Create booking functionality not implemented yet')),
                            );
                          },
                          tooltip: 'Create booking',
                          color: kPrimaryColor,
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
