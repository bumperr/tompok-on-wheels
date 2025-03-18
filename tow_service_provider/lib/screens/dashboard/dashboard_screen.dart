import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data for the dashboard
  final int _todayBookings = 5;
  final int _pendingBookings = 3;
  final int _completedBookings = 2;
  final double _todayRevenue = 320.0;
  final int _activePets = 12;
  final int _totalCustomers = 8;
  bool _isSidebarOpen = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample recent bookings
  final List<Map<String, dynamic>> _recentBookings = [
    {
      'id': 'B001',
      'customerName': 'John Doe',
      'petName': 'Oyen',
      'service': 'Basic Grooming',
      'date': DateTime.now().add(const Duration(hours: 2)),
      'status': 'Confirmed',
      'price': 80.0,
    },
    {
      'id': 'B002',
      'customerName': 'Jane Smith',
      'petName': 'Tompok',
      'service': 'Health Check',
      'date': DateTime.now().add(const Duration(hours: 4)),
      'status': 'Pending',
      'price': 120.0,
    },
    {
      'id': 'B003',
      'customerName': 'Wei Lin',
      'petName': 'Whiskers',
      'service': 'Boarding - Standard',
      'date': DateTime.now().add(const Duration(days: 1)),
      'status': 'Confirmed',
      'price': 150.0,
    },
  ];

  // Sample revenue data for chart
  final List<FlSpot> _revenueData = [
    FlSpot(0, 150),
    FlSpot(1, 220),
    FlSpot(2, 180),
    FlSpot(3, 250),
    FlSpot(4, 300),
    FlSpot(5, 270),
    FlSpot(6, 320),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Dashboard'),
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
                currentRoute: AppRoutes.dashboardRoute,
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
            SidebarMenu(currentRoute: AppRoutes.dashboardRoute),

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
                    _isSidebarOpen
                        ? Icons.chevron_left
                        : Icons.chevron_right,
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
                    _buildDashboardHeader(),
                    const SizedBox(height: 32),

                    // Summary cards
                    _buildSummaryCards(isSmallScreen),
                    const SizedBox(height: 32),

                    // Upcoming bookings and Revenue chart
                    _buildDetailsRow(isSmallScreen),
                    const SizedBox(height: 32),

                    // Recent activity section
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader() {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Booking'),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.bookingsRoute);
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isSmallScreen) {
    // Define card items
    final List<Map<String, dynamic>> cardItems = [
      {
        'title': 'Today\'s Bookings',
        'value': _todayBookings,
        'icon': Icons.calendar_today,
        'color': kBookingCardColor,
        'route': AppRoutes.bookingsRoute,
      },
      {
        'title': 'Pending Bookings',
        'value': _pendingBookings,
        'icon': Icons.schedule,
        'color': kPendingColor,
        'route': AppRoutes.bookingsRoute,
      },
      {
        'title': 'Today\'s Revenue',
        'value': 'RM ${_todayRevenue.toStringAsFixed(2)}',
        'icon': Icons.attach_money,
        'color': kRevenueCardColor,
        'route': AppRoutes.financesRoute,
      },
      {
        'title': 'Active Pets',
        'value': _activePets,
        'icon': Icons.pets,
        'color': kPetCardColor,
        'route': AppRoutes.petsRoute,
      },
    ];

    // Calculate responsive grid
    int crossAxisCount = 4;
    if (MediaQuery.of(context).size.width < 1400) crossAxisCount = 2;
    if (MediaQuery.of(context).size.width < 800) crossAxisCount = 1;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cardItems.length,
      itemBuilder: (context, index) {
        final item = cardItems[index];
        return _buildSummaryCard(
          title: item['title'],
          value: item['value'],
          icon: item['icon'],
          color: item['color'],
          onTap: () => Navigator.pushNamed(context, item['route']),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required dynamic value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsRow(bool isSmallScreen) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildUpcomingBookingsCard(),
            ),
            if (!isSmallScreen) const SizedBox(width: 24),
            if (!isSmallScreen)
              Expanded(
                flex: 4,
                child: _buildRevenueChart(),
              ),
          ],
        ),
        if (isSmallScreen) const SizedBox(height: 24),
        if (isSmallScreen) _buildRevenueChart(),
      ],
    );
  }

  Widget _buildUpcomingBookingsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming'
                  'Upcoming Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.bookingsRoute);
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_recentBookings.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No upcoming bookings',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentBookings.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final booking = _recentBookings[index];
                  final date = booking['date'] as DateTime;
                  final formattedDate = DateFormat('MMM d, h:mm a').format(date);
                  final statusColor = booking['status'] == 'Confirmed'
                      ? kConfirmedColor
                      : booking['status'] == 'Pending'
                          ? kPendingColor
                          : kInProgressColor;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        booking['petName'][0],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      booking['service'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${booking['customerName']} • $formattedDate',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'RM ${booking['price'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
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
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.bookingDetailsRoute,
                        arguments: booking['id'],
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weekly Revenue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'This Week',
                  items: ['This Week', 'Last Week', 'This Month', 'Last Month']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // In a real app, this would update the chart data
                  },
                  underline: Container(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          final dayIndex = value.toInt();
                          if (dayIndex >= 0 && dayIndex < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                days[dayIndex],
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 400,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _revenueData,
                      isCurved: true,
                      color: kPrimaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: kPrimaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: kPrimaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    title: 'Completed Services',
                    value: _completedBookings.toString(),
                    icon: Icons.check_circle,
                    color: kCompletedColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatisticCard(
                    title: 'Total Revenue (Week)',
                    value: 'RM 1,250.00',
                    icon: Icons.attach_money,
                    color: kRevenueCardColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatisticCard(
                    title: 'Total Customers',
                    value: _totalCustomers.toString(),
                    icon: Icons.people,
                    color: kCustomerCardColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'New Booking',
                    icon: Icons.add_circle,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.bookingsRoute);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    label: 'Add Service',
                    icon: Icons.spa,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.addServiceRoute);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    label: 'View Calendar',
                    icon: Icons.calendar_today,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.calendarRoute);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
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
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}