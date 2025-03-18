import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isSidebarOpen = true;
  String _selectedTimeRange = 'This Month';
  String _selectedChart = 'Revenue';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<FlSpot> _revenueData = [
    FlSpot(0, 150),
    FlSpot(1, 220),
    FlSpot(2, 180),
    FlSpot(3, 250),
    FlSpot(4, 300),
    FlSpot(5, 270),
    FlSpot(6, 320)
  ];
  final List<FlSpot> _bookingsData = [
    FlSpot(0, 3),
    FlSpot(1, 5),
    FlSpot(2, 4),
    FlSpot(3, 6),
    FlSpot(4, 7),
    FlSpot(5, 5),
    FlSpot(6, 8)
  ];
  final List<FlSpot> _customersData = [
    FlSpot(0, 2),
    FlSpot(1, 3),
    FlSpot(2, 2),
    FlSpot(3, 4),
    FlSpot(4, 3),
    FlSpot(5, 2),
    FlSpot(6, 5)
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1100;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text('Analytics'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            )
          : null,
      drawer: isSmallScreen
          ? Drawer(child: SidebarMenu(currentRoute: AppRoutes.analyticsRoute))
          : null,
      body: Row(
        children: [
          if (!isSmallScreen && _isSidebarOpen)
            SidebarMenu(currentRoute: AppRoutes.analyticsRoute),
          if (!isSmallScreen)
            InkWell(
              onTap: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
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
          Expanded(
            child: Container(
              color: kBackgroundColor,
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildMainChart(),
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
        const Text(
          'Business Analytics',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: _selectedTimeRange,
          items: [
            'Today',
            'This Week',
            'This Month',
            'This Quarter',
            'This Year'
          ]
              .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (value) => setState(() => _selectedTimeRange = value!),
          underline: Container(),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Widget _buildMainChart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  'Performance Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _selectedChart,
                  items: ['Revenue', 'Bookings', 'Customers']
                      .map((value) =>
                          DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedChart = value!),
                  underline: Container(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(height: 280, child: LineChart(_getLineChartData())),
          ],
        ),
      ),
    );
  }

  LineChartData _getLineChartData() {
    List<FlSpot> spots;
    Color lineColor;
    switch (_selectedChart) {
      case 'Bookings':
        spots = _bookingsData;
        lineColor = kBookingCardColor;
        break;
      case 'Customers':
        spots = _customersData;
        lineColor = kCustomerCardColor;
        break;
      case 'Revenue':
      default:
        spots = _revenueData;
        lineColor = kRevenueCardColor;
        break;
    }

    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: _selectedChart == 'Revenue' ? 400 : 10,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: lineColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData:
              BarAreaData(show: true, color: lineColor.withOpacity(0.2)),
        ),
      ],
    );
  }
}
