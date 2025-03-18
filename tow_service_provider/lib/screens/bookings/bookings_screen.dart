import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/models/booking.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedDate = 'All';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample bookings data
  final List<Booking> _bookings = [
    Booking(
      id: 'B001',
      customerId: 'C001',
      customerName: 'John Doe',
      customerPhone: '+60123456789',
      customerEmail: 'john.doe@example.com',
      petId: 'P001',
      petName: 'Oyen',
      petType: 'Cat',
      petBreed: 'Domestic Shorthair',
      petAge: 3,
      petImageUrl: 'https://example.com/pet1.jpg',
      providerId: 'SP001',
      serviceId: 'S001',
      serviceName: 'Basic Grooming',
      servicePrice: 80.00,
      date: DateTime.now().add(const Duration(hours: 2)),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      status: BookingStatus.confirmed,
      totalPrice: 80.00,
    ),
    Booking(
      id: 'B002',
      customerId: 'C002',
      customerName: 'Jane Smith',
      customerPhone: '+60123456790',
      customerEmail: 'jane.smith@example.com',
      petId: 'P002',
      petName: 'Tompok',
      petType: 'Cat',
      petBreed: 'Siamese',
      petAge: 2,
      petImageUrl: 'https://example.com/pet2.jpg',
      providerId: 'SP001',
      serviceId: 'S003',
      serviceName: 'Health Check-up',
      servicePrice: 120.00,
      date: DateTime.now().add(const Duration(hours: 4)),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 14, minute: 30),
      status: BookingStatus.pending,
      totalPrice: 120.00,
    ),
    Booking(
      id: 'B003',
      customerId: 'C003',
      customerName: 'Wei Lin',
      customerPhone: '+60123456791',
      customerEmail: 'wei.lin@example.com',
      petId: 'P003',
      petName: 'Whiskers',
      petType: 'Cat',
      petBreed: 'Persian',
      petAge: 4,
      petImageUrl: 'https://example.com/pet3.jpg',
      providerId: 'SP001',
      serviceId: 'S004',
      serviceName: 'Boarding - Standard',
      servicePrice: 45.00,
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
      status: BookingStatus.confirmed,
      totalPrice: 45.00,
    ),
    Booking(
      id: 'B004',
      customerId: 'C001',
      customerName: 'John Doe',
      customerPhone: '+60123456789',
      customerEmail: 'john.doe@example.com',
      petId: 'P001',
      petName: 'Oyen',
      petType: 'Cat',
      petBreed: 'Domestic Shorthair',
      petAge: 3,
      petImageUrl: 'https://example.com/pet1.jpg',
      providerId: 'SP001',
      serviceId: 'S002',
      serviceName: 'Premium Grooming',
      servicePrice: 120.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      startTime: const TimeOfDay(hour: 13, minute: 0),
      endTime: const TimeOfDay(hour: 14, minute: 30),
      status: BookingStatus.completed,
      totalPrice: 120.00,
      isPaid: true,
    ),
    Booking(
      id: 'B005',
      customerId: 'C004',
      customerName: 'Sarah Johnson',
      customerPhone: '+60123456792',
      customerEmail: 'sarah.j@example.com',
      petId: 'P004',
      petName: 'Bella',
      petType: 'Cat',
      petBreed: 'Maine Coon',
      petAge: 5,
      petImageUrl: 'https://example.com/pet4.jpg',
      providerId: 'SP001',
      serviceId: 'S001',
      serviceName: 'Basic Grooming',
      servicePrice: 80.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      startTime: const TimeOfDay(hour: 11, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      status: BookingStatus.cancelled,
      totalPrice: 80.00,
    ),
    Booking(
      id: 'B006',
      customerId: 'C005',
      customerName: 'Ahmad Razali',
      customerPhone: '+60123456793',
      customerEmail: 'ahmad.r@example.com',
      petId: 'P005',
      petName: 'Leo',
      petType: 'Cat',
      petBreed: 'Bengal',
      petAge: 3,
      petImageUrl: 'https://example.com/pet5.jpg',
      providerId: 'SP001',
      serviceId: 'S005',
      serviceName: 'Boarding - Deluxe',
      servicePrice: 75.00,
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      needsTransportation: true,
      status: BookingStatus.confirmed,
      totalPrice: 75.00,
      driverName: 'Malik',
      driverPhone: '+60123456794',
    ),
  ];

  // Filtered bookings based on search and filters
  List<Booking> get filteredBookings {
    return _bookings.where((booking) {
      // Filter by search query
      final matchesSearch = booking.customerName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          booking.petName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          booking.serviceName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          booking.id.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by status
      final matchesStatus = _selectedStatus == 'All' ||
          booking.status.toString().split('.').last.toLowerCase() ==
              _selectedStatus.toLowerCase();

      // Filter by date
      bool matchesDate = false;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final bookingDate =
          DateTime(booking.date.year, booking.date.month, booking.date.day);

      switch (_selectedDate) {
        case 'All':
          matchesDate = true;
          break;
        case 'Today':
          matchesDate = bookingDate.isAtSameMomentAs(today);
          break;
        case 'Tomorrow':
          final tomorrow = today.add(const Duration(days: 1));
          matchesDate = bookingDate.isAtSameMomentAs(tomorrow);
          break;
        case 'This Week':
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          matchesDate = bookingDate
                  .isAfter(weekStart.subtract(const Duration(days: 1))) &&
              bookingDate.isBefore(weekEnd.add(const Duration(days: 1)));
          break;
        case 'Upcoming':
          matchesDate =
              bookingDate.isAfter(today.subtract(const Duration(days: 1)));
          break;
        case 'Past':
          matchesDate = bookingDate.isBefore(today);
          break;
      }

      return matchesSearch && matchesStatus && matchesDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Bookings'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar menu for large screens
          if (!isSmallScreen && _isSidebarOpen)
            SidebarMenu(currentRoute: AppRoutes.bookingsRoute),

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

                  // Bookings list
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildBookingsList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: isSmallScreen
          ? Drawer(
              child: SidebarMenu(
                currentRoute: AppRoutes.bookingsRoute,
                onMenuItemSelected: () {
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to create booking page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Add booking functionality not implemented yet')),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Bookings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('View Calendar'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.calendarRoute);
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Booking'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Add booking functionality not implemented yet')),
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
                hintText: 'Search by name, service, or ID...',
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

          // Status filter
          DropdownButton<String>(
            value: _selectedStatus,
            items: [
              'All',
              'Pending',
              'Confirmed',
              'InTransit',
              'InProgress',
              'Completed',
              'Cancelled',
              'NoShow'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
            hint: const Text('Status'),
          ),
          const SizedBox(width: 16),

          // Date filter
          DropdownButton<String>(
            value: _selectedDate,
            items: ['All', 'Today', 'Tomorrow', 'This Week', 'Upcoming', 'Past']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDate = value!;
              });
            },
            hint: const Text('Date'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or create a new booking',
              style: TextStyle(
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
        itemCount: filteredBookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final statusColor = booking.getStatusColor();
    final statusText = booking.getStatusText();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: booking.isToday
              ? kPrimaryColor.withOpacity(0.5)
              : Colors.transparent,
          width: booking.isToday ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bookingDetailsRoute,
            arguments: booking.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Date and time
                  Container(
                    width: 90,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('MMM').format(booking.date),
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd').format(booking.date),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          DateFormat('E').format(booking.date),
                          style: TextStyle(
                            color: kPrimaryColor,
                          ),
                        ),
                        const Divider(height: 12),
                        Text(
                          DateFormat('HH:mm').format(
                            DateTime(
                              booking.date.year,
                              booking.date.month,
                              booking.date.day,
                              booking.startTime.hour,
                              booking.startTime.minute,
                            ),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Middle: Booking details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking.serviceName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                statusText,
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
                            const Icon(
                              Icons.pets,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${booking.petName} (${booking.petBreed})',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              booking.customerName,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (booking.needsTransportation) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.local_taxi,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Transportation Required',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (booking.driverName != null) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '• ${booking.driverName}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      ],
                    ),
                  ),

                  // Right side: Price and actions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'RM ${booking.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.isPaid ? 'Paid' : 'Unpaid',
                        style: TextStyle(
                          color: booking.isPaid ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              // Call customer
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Calling ${booking.customerName}')),
                              );
                            },
                            tooltip: 'Call customer',
                            visualDensity: VisualDensity.compact,
                            iconSize: 20,
                            color: kPrimaryColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.message),
                            onPressed: () {
                              // Message customer
                              Navigator.pushNamed(
                                context,
                                AppRoutes.chatRoute,
                                arguments: booking.customerId,
                              );
                            },
                            tooltip: 'Message customer',
                            visualDensity: VisualDensity.compact,
                            iconSize: 20,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (booking.notes.isNotEmpty) ...[
                const Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.note,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Notes: ${booking.notes}',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
