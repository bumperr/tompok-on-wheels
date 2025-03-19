// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/models/booking.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

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

  // Get bookings for a specific day
  List<Booking> _getBookingsForDay(DateTime day) {
    return _bookings.where((booking) {
      return booking.date.year == day.year &&
          booking.date.month == day.month &&
          booking.date.day == day.day;
    }).toList();
  }

  // Check if a day has bookings
  bool _hasBookings(DateTime day) {
    return _getBookingsForDay(day).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Calendar View'),
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
                currentRoute: AppRoutes.calendarRoute,
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
      body: Row(
        children: [
          // Sidebar menu for large screens
          if (!isSmallScreen && _isSidebarOpen)
            SidebarMenu(currentRoute: AppRoutes.calendarRoute),

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
                  // Header with title and actions
                  _buildHeader(),

                  // Calendar and bookings view
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildCalendarWithBookings(),
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
                'Calendar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Viewing all bookings',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('List View'),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.bookingsRoute);
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

  Widget _buildCalendarWithBookings() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calendar part
        Expanded(
          flex: 2,
          child: Card(
            margin:
                const EdgeInsets.only(left: 24.0, right: 12.0, bottom: 24.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) {
                      return _getBookingsForDay(day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 3,
                      markerDecoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonDecoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: kPrimaryColor,
                      ),
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        _buildCalendarLegendItem(
                          color: kPrimaryColor,
                          label: 'Bookings',
                        ),
                        const SizedBox(width: 16),
                        _buildCalendarLegendItem(
                          color: kConfirmedColor,
                          label: 'Confirmed',
                        ),
                        const SizedBox(width: 16),
                        _buildCalendarLegendItem(
                          color: kPendingColor,
                          label: 'Pending',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bookings for selected day
        Expanded(
          flex: 3,
          child: Card(
            margin:
                const EdgeInsets.only(left: 12.0, right: 24.0, bottom: 24.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bookings for ${DateFormat('MMMM d, yyyy').format(_selectedDay)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_getBookingsForDay(_selectedDay).length} Bookings',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _buildBookingsForSelectedDay(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsForSelectedDay() {
    final bookingsForDay = _getBookingsForDay(_selectedDay);

    if (bookingsForDay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings for this day',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
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
      );
    }

    // Sort bookings by time
    bookingsForDay.sort((a, b) {
      final aTime = a.startTime.hour * 60 + a.startTime.minute;
      final bTime = b.startTime.hour * 60 + b.startTime.minute;
      return aTime.compareTo(bTime);
    });

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: bookingsForDay.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookingsForDay[index];
        return _buildTimelineBookingItem(booking);
      },
    );
  }

  Widget _buildTimelineBookingItem(Booking booking) {
    final statusColor = booking.getStatusColor();

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.bookingDetailsRoute,
          arguments: booking.id,
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline and time
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatTimeOfDay(booking.startTime),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                if (booking.endTime != null) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    width: 1,
                    height: 20,
                    color: Colors.grey.shade300,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatTimeOfDay(booking.endTime!),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(width: 16),

            // Booking details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          booking.serviceName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          booking.getStatusText(),
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
                        '${booking.petName} (${booking.petType})',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.customerName,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (booking.needsTransportation) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_taxi,
                          size: 16,
                          color: kAccentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Transportation Required',
                          style: TextStyle(
                            color: kAccentColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'RM ${booking.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Edit booking
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit booking not implemented yet'),
                          ),
                        );
                      },
                      tooltip: 'Edit booking',
                      iconSize: 18,
                      visualDensity: VisualDensity.compact,
                      splashRadius: 20,
                      color: kPrimaryColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.bookingDetailsRoute,
                          arguments: booking.id,
                        );
                      },
                      tooltip: 'View details',
                      iconSize: 18,
                      visualDensity: VisualDensity.compact,
                      splashRadius: 20,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
