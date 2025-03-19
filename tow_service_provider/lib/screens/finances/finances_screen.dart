import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancesScreen extends StatefulWidget {
  const FinancesScreen({Key? key}) : super(key: key);

  @override
  _FinancesScreenState createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  String _timeRange = 'This Month';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample financial data
  final Map<String, dynamic> _financialSummary = {
    'totalEarnings': 3580.00,
    'pendingPayouts': 420.00,
    'completedBookings': 24,
    'pendingBookings': 6,
    'averageBookingValue': 149.17,
    'monthlyTrend': [
      {'month': 'Jan', 'earnings': 2800.00},
      {'month': 'Feb', 'earnings': 3100.00},
      {'month': 'Mar', 'earnings': 2900.00},
      {'month': 'Apr', 'earnings': 3200.00},
      {'month': 'May', 'earnings': 3400.00},
      {'month': 'Jun', 'earnings': 3580.00},
    ],
    'serviceBreakdown': [
      {'service': 'Grooming', 'earnings': 1800.00, 'percentage': 50.28},
      {'service': 'Boarding', 'earnings': 980.00, 'percentage': 27.37},
      {'service': 'Veterinary', 'earnings': 800.00, 'percentage': 22.35},
    ],
  };

  // Sample recent transactions
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 'T001',
      'customerId': 'C001',
      'customerName': 'John Doe',
      'bookingId': 'B001',
      'serviceName': 'Basic Grooming',
      'amount': 80.00,
      'status': 'Completed',
      'paymentMethod': 'Credit Card',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 'T002',
      'customerId': 'C002',
      'customerName': 'Jane Smith',
      'bookingId': 'B002',
      'serviceName': 'Health Check-up',
      'amount': 120.00,
      'status': 'Completed',
      'paymentMethod': 'Cash',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 'T003',
      'customerId': 'C003',
      'customerName': 'Wei Lin',
      'bookingId': 'B003',
      'serviceName': 'Boarding - Standard (3 days)',
      'amount': 135.00,
      'status': 'Pending',
      'paymentMethod': 'Credit Card',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': 'T004',
      'customerId': 'C004',
      'customerName': 'Sarah Johnson',
      'bookingId': 'B004',
      'serviceName': 'Premium Grooming',
      'amount': 120.00,
      'status': 'Completed',
      'paymentMethod': 'Credit Card',
      'date': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': 'T005',
      'customerId': 'C005',
      'customerName': 'Ahmad Razali',
      'bookingId': 'B005',
      'serviceName': 'Boarding - Deluxe (2 days)',
      'amount': 150.00,
      'status': 'Completed',
      'paymentMethod': 'Online Banking',
      'date': DateTime.now().subtract(const Duration(days: 8)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Finances'),
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
                currentRoute: AppRoutes.financesRoute,
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
            SidebarMenu(currentRoute: AppRoutes.financesRoute),

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
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildFinancialSummary(),
                          const SizedBox(height: 24),
                          _buildEarningsChart(),
                          const SizedBox(height: 24),
                          _buildServiceBreakdown(),
                          const SizedBox(height: 24),
                          _buildRecentTransactions(),
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
              'Financial Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Track your earnings and financial performance',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _timeRange,
              items: [
                'This Week',
                'This Month',
                'Last Month',
                'Last 3 Months',
                'This Year'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _timeRange = newValue;
                  });
                }
              },
              icon: const Icon(Icons.keyboard_arrow_down),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Earnings',
            value:
                'RM ${_financialSummary['totalEarnings'].toStringAsFixed(2)}',
            icon: Icons.attach_money,
            color: kRevenueCardColor,
            subtitle: '$_timeRange',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            title: 'Pending Payouts',
            value:
                'RM ${_financialSummary['pendingPayouts'].toStringAsFixed(2)}',
            icon: Icons.pending_actions,
            color: kPendingColor,
            subtitle: '${_financialSummary['pendingBookings']} bookings',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            title: 'Completed Bookings',
            value: '${_financialSummary['completedBookings']}',
            icon: Icons.check_circle_outline,
            color: kCompletedColor,
            subtitle:
                'Avg RM ${_financialSummary['averageBookingValue'].toStringAsFixed(2)}',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildEarningsChart() {
    final monthlyData = _financialSummary['monthlyTrend'] as List;

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
            const Text(
              'Earnings Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 4000,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey.shade800,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          'RM ${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < monthlyData.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 16,
                              child: Text(
                                monthlyData[index]['month'],
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
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
                        interval: 1000,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 0,
                            child: Text(
                              value == 0 ? '0' : '${value ~/ 1000}k',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: List.generate(
                    monthlyData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: monthlyData[index]['earnings'],
                          color: kRevenueCardColor,
                          width: 22,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBreakdown() {
    final serviceData = _financialSummary['serviceBreakdown'] as List;
    final colors = [
      kPrimaryColor,
      kAccentColor,
      kBookingCardColor,
      kPetCardColor,
      kRevenueCardColor,
    ];

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
            const Text(
              'Revenue by Service Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Pie chart
                SizedBox(
                  height: 200,
                  width: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: List.generate(
                        serviceData.length,
                        (index) {
                          return PieChartSectionData(
                            color: colors[index % colors.length],
                            value: serviceData[index]['percentage'],
                            title:
                                '${serviceData[index]['percentage'].toStringAsFixed(1)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),

                // Legend
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      serviceData.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: colors[index % colors.length],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                serviceData[index]['service'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'RM ${serviceData[index]['earnings'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
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
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.visibility),
                  label: const Text('View All'),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.transactionsRoute);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Customer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Service',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

            // Transaction items
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  _recentTransactions.length.clamp(0, 5), // Show max 5 items
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final transaction = _recentTransactions[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          transaction['customerName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          transaction['serviceName'],
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'RM ${transaction['amount'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: transaction['status'] == 'Completed'
                                ? kCompletedColor.withOpacity(0.1)
                                : kPendingColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            transaction['status'],
                            style: TextStyle(
                              color: transaction['status'] == 'Completed'
                                  ? kCompletedColor
                                  : kPendingColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat('MMM d, yyyy').format(transaction['date']),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // View all button for mobile
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text('View All Transactions'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.transactionsRoute);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
