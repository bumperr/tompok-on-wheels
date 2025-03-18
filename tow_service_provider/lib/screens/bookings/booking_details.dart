import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/models/booking.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({Key? key}) : super(key: key);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool _isSidebarOpen = true;
  bool _isLoading = true;
  late Booking _booking;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample booking data - in a real app, this would be fetched from an API
  final Booking _sampleBooking = Booking(
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
    petImageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
    providerId: 'SP001',
    serviceId: 'S001',
    serviceName: 'Basic Grooming',
    servicePrice: 80.00,
    date: DateTime.now().add(const Duration(hours: 2)),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    status: BookingStatus.confirmed,
    totalPrice: 80.00,
    notes: 'Pet has sensitive skin, please use hypoallergenic shampoo.',
    specialInstructions: [
      'Use gentle shampoo',
      'Be careful with claws',
      'No perfume sprays',
    ],
    needsTransportation: true,
  );

  @override
  void initState() {
    super.initState();
    // In a real app, we would fetch the booking details using the ID
    // For this demo, we'll use a slight delay to simulate API fetch
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _booking = _sampleBooking;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    // Get booking ID from route arguments if available
    final bookingId =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'B001';

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: Text('Booking #${bookingId.substring(1)}'),
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
                currentRoute: AppRoutes.bookingsRoute,
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildBookingDetails(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with booking ID and status
        _buildHeader(),
        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column - Customer and pet details
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer & Pet Details
                  _buildCustomerAndPetDetails(),
                  const SizedBox(height: 24),

                  // Service Details
                  _buildServiceDetails(),
                  const SizedBox(height: 24),

                  // Special Instructions
                  _buildSpecialInstructions(),
                ],
              ),
            ),
            const SizedBox(width: 24),

            // Right column - Transportation & actions
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking status card
                  _buildStatusCard(),
                  const SizedBox(height: 24),

                  // Transportation details if needed
                  if (_booking.needsTransportation) _buildTransportationCard(),
                  if (_booking.needsTransportation) const SizedBox(height: 24),

                  // Action buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Booking #${_booking.id.substring(1)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                'Created on ${DateFormat('MMM d, yyyy').format(_booking.createdAt)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _booking.getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _booking.getStatusColor().withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getStatusIcon(_booking.status),
                color: _booking.getStatusColor(),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _booking.getStatusText(),
                style: TextStyle(
                  color: _booking.getStatusColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerAndPetDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Details
            const Text(
              'Customer Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _booking.customerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _booking.customerPhone,
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
                            Icons.email,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _booking.customerEmail,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () {
                        // Call customer
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Calling ${_booking.customerName}')),
                        );
                      },
                      tooltip: 'Call customer',
                      color: kPrimaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                        // Message customer
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatRoute,
                          arguments: _booking.customerId,
                        );
                      },
                      tooltip: 'Message customer',
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 40),

            // Pet Details
            const Text(
              'Pet Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _booking.petImageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.pets,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _booking.petName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.category,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _booking.petType,
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
                            Icons.pets,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _booking.petBreed,
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
                            Icons.cake,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_booking.petAge} years old',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View Pet Profile'),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.petDetailsRoute,
                      arguments: _booking.petId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Card(
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
              'Service Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Service info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.spa,
                    color: kPrimaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _booking.serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _booking.formattedDuration,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'RM ${_booking.servicePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // Date and time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(_booking.date),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_timeOfDayFormat(_booking.startTime)} - ${_booking.endTime != null ? _timeOfDayFormat(_booking.endTime!) : 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (_booking.notes.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notes,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _booking.notes,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    if (_booking.specialInstructions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
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
              'Special Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _booking.specialInstructions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: kPrimaryColor,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _booking.specialInstructions[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
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
              'Booking Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Status progress indicator
            _buildStatusProgress(),
            const SizedBox(height: 24),

            // Payment status
            Row(
              children: [
                const Text(
                  'Payment Status:',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _booking.isPaid
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _booking.isPaid ? 'Paid' : 'Unpaid',
                    style: TextStyle(
                      color: _booking.isPaid
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Total price
            Row(
              children: [
                const Text(
                  'Total Price:',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                Text(
                  'RM ${_booking.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusProgress() {
    final statuses = [
      BookingStatus.pending,
      BookingStatus.confirmed,
      BookingStatus.inTransit,
      BookingStatus.inProgress,
      BookingStatus.completed,
    ];

    final currentIndex = statuses.indexOf(_booking.status);
    final isActive = (index) =>
        index <= currentIndex &&
        _booking.status != BookingStatus.cancelled &&
        _booking.status != BookingStatus.noShow;

    if (_booking.status == BookingStatus.cancelled ||
        _booking.status == BookingStatus.noShow) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              _booking.status == BookingStatus.cancelled
                  ? Icons.cancel
                  : Icons.event_busy,
              color: Colors.red.shade700,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _booking.status == BookingStatus.cancelled
                    ? 'This booking has been cancelled.'
                    : 'Customer did not show up for this booking.',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: List.generate(statuses.length, (index) {
            final isLast = index == statuses.length - 1;
            return Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isActive(index) ? kPrimaryColor : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: isActive(index)
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isActive(index + 1)
                          ? kPrimaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusLabel('Pending', isActive(0)),
            _buildStatusLabel('Confirmed', isActive(1)),
            _buildStatusLabel('In Transit', isActive(2)),
            _buildStatusLabel('In Progress', isActive(3)),
            _buildStatusLabel('Completed', isActive(4)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusLabel(String label, bool isActive) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        color: isActive ? kPrimaryColor : Colors.grey.shade600,
      ),
    );
  }

  Widget _buildTransportationCard() {
    return Card(
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
              children: [
                Icon(
                  Icons.local_taxi,
                  color: kAccentColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Transportation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_booking.driverId != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _booking.driverName ?? 'Driver Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _booking.driverPhone ?? 'Driver Phone',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () {
                      // Call driver
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Calling ${_booking.driverName}')),
                      );
                    },
                    color: kPrimaryColor,
                    iconSize: 20,
                  ),
                ],
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driver Not Assigned',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'A driver has not been assigned to this booking yet.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Assign Driver'),
                  onPressed: () {
                    // Assign driver
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Driver assignment feature not implemented yet')),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    List<Widget> buttons = [];

    // Different buttons based on booking status
    switch (_booking.status) {
      case BookingStatus.pending:
        buttons = [
          _buildActionButton(
            label: 'Confirm Booking',
            icon: Icons.check_circle,
            color: Colors.green,
            onPressed: () => _updateBookingStatus(BookingStatus.confirmed),
          ),
          _buildActionButton(
            label: 'Cancel Booking',
            icon: Icons.cancel,
            color: Colors.red,
            onPressed: () => _updateBookingStatus(BookingStatus.cancelled),
          ),
        ];
        break;
      case BookingStatus.confirmed:
        if (_booking.needsTransportation) {
          buttons = [
            _buildActionButton(
              label: 'Mark as In Transit',
              icon: Icons.local_taxi,
              color: Colors.blue,
              onPressed: () => _updateBookingStatus(BookingStatus.inTransit),
            ),
          ];
        } else {
          buttons = [
            _buildActionButton(
              label: 'Start Service',
              icon: Icons.play_circle_fill,
              color: Colors.blue,
              onPressed: () => _updateBookingStatus(BookingStatus.inProgress),
            ),
          ];
        }
        buttons.add(
          _buildActionButton(
            label: 'Cancel Booking',
            icon: Icons.cancel,
            color: Colors.red,
            onPressed: () => _updateBookingStatus(BookingStatus.cancelled),
          ),
        );
        break;
      case BookingStatus.inTransit:
        buttons = [
          _buildActionButton(
            label: 'Start Service',
            icon: Icons.play_circle_fill,
            color: Colors.blue,
            onPressed: () => _updateBookingStatus(BookingStatus.inProgress),
          ),
          _buildActionButton(
            label: 'Mark as No-Show',
            icon: Icons.event_busy,
            color: Colors.red,
            onPressed: () => _updateBookingStatus(BookingStatus.noShow),
          ),
        ];
        break;
      case BookingStatus.inProgress:
        buttons = [
          _buildActionButton(
            label: 'Complete Service',
            icon: Icons.task_alt,
            color: Colors.green,
            onPressed: () => _updateBookingStatus(BookingStatus.completed),
          ),
        ];
        break;
      case BookingStatus.completed:
        buttons = [
          if (!_booking.isPaid)
            _buildActionButton(
              label: 'Mark as Paid',
              icon: Icons.payments,
              color: Colors.green,
              onPressed: _markAsPaid,
            ),
          _buildActionButton(
            label: 'View Receipt',
            icon: Icons.receipt_long,
            color: kPrimaryColor,
            onPressed: _viewReceipt,
          ),
        ];
        break;
      case BookingStatus.cancelled:
        buttons = [
          _buildActionButton(
            label: 'Reactivate Booking',
            icon: Icons.refresh,
            color: Colors.blue,
            onPressed: () => _updateBookingStatus(BookingStatus.pending),
          ),
        ];
        break;
      case BookingStatus.noShow:
        buttons = [
          _buildActionButton(
            label: 'Reactivate Booking',
            icon: Icons.refresh,
            color: Colors.blue,
            onPressed: () => _updateBookingStatus(BookingStatus.pending),
          ),
        ];
        break;
    }

    // Add common actions for all states
    buttons.add(
      OutlinedButton.icon(
        icon: const Icon(Icons.edit),
        label: const Text('Edit Booking'),
        onPressed: _editBooking,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
        ),
      ),
    );

    // Build the column of buttons
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...buttons.map((button) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: button,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 45),
      ),
    );
  }

  void _updateBookingStatus(BookingStatus newStatus) {
    // In a real app, this would call an API to update the booking status
    setState(() {
      _booking = _booking.copyWith(status: newStatus);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Booking status updated to ${_booking.getStatusText()}')),
    );
  }

  void _markAsPaid() {
    // In a real app, this would call an API to update the payment status
    setState(() {
      _booking = _booking.copyWith(isPaid: true);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking marked as paid')),
    );
  }

  void _viewReceipt() {
    // View receipt functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Receipt viewing functionality not implemented yet')),
    );
  }

  void _editBooking() {
    // Edit booking functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Booking editing functionality not implemented yet')),
    );
  }

  String _timeOfDayFormat(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.watch_later;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.inTransit:
        return Icons.local_taxi;
      case BookingStatus.inProgress:
        return Icons.handyman;
      case BookingStatus.completed:
        return Icons.task_alt;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.noShow:
        return Icons.event_busy;
    }
  }
}
