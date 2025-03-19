import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/widgets/sidebar_menu.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  bool _isSidebarOpen = true;
  bool _isLoading = false;
  String _filterStatus = 'All';
  String _filterDate = 'All Time';
  String _searchQuery = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample transactions data
  final List<Map<String, dynamic>> _transactions = [
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
    {
      'id': 'T006',
      'customerId': 'C001',
      'customerName': 'John Doe',
      'bookingId': 'B006',
      'serviceName': 'Basic Grooming',
      'amount': 80.00,
      'status': 'Refunded',
      'paymentMethod': 'Credit Card',
      'date': DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      'id': 'T007',
      'customerId': 'C006',
      'customerName': 'Michael Wong',
      'bookingId': 'B007',
      'serviceName': 'Veterinary Check-up',
      'amount': 150.00,
      'status': 'Completed',
      'paymentMethod': 'Cash',
      'date': DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      'id': 'T008',
      'customerId': 'C007',
      'customerName': 'Lisa Chen',
      'bookingId': 'B008',
      'serviceName': 'Premium Grooming',
      'amount': 120.00,
      'status': 'Pending',
      'paymentMethod': 'Credit Card',
      'date': DateTime.now().subtract(const Duration(days: 20)),
    },
    {
      'id': 'T009',
      'customerId': 'C008',
      'customerName': 'Mohammed Ali',
      'bookingId': 'B009',
      'serviceName': 'Boarding - Standard (5 days)',
      'amount': 225.00,
      'status': 'Completed',
      'paymentMethod': 'Online Banking',
      'date': DateTime.now().subtract(const Duration(days: 25)),
    },
    {
      'id': 'T010',
      'customerId': 'C009',
      'customerName': 'Samantha Lee',
      'bookingId': 'B010',
      'serviceName': 'Basic Grooming',
      'amount': 80.00,
      'status': 'Completed',
      'paymentMethod': 'Cash',
      'date': DateTime.now().subtract(const Duration(days: 30)),
    },
  ];

  // Filtered transactions based on search, status and date filters
  List<Map<String, dynamic>> get filteredTransactions {
    return _transactions.where((transaction) {
      // Filter by search query
      final matchesSearch = transaction['customerName']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          transaction['serviceName']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          transaction['id'].toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by status
      final matchesStatus =
          _filterStatus == 'All' || transaction['status'] == _filterStatus;

      // Filter by date
      bool matchesDate = false;
      final transactionDate = transaction['date'] as DateTime;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      switch (_filterDate) {
        case 'All Time':
          matchesDate = true;
          break;
        case 'Today':
          final date = DateTime(
              transactionDate.year, transactionDate.month, transactionDate.day);
          matchesDate = date.isAtSameMomentAs(today);
          break;
        case 'This Week':
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          matchesDate = transactionDate
                  .isAfter(weekStart.subtract(const Duration(days: 1))) &&
              transactionDate.isBefore(weekEnd.add(const Duration(days: 1)));
          break;
        case 'This Month':
          matchesDate = transactionDate.year == now.year &&
              transactionDate.month == now.month;
          break;
        case 'Last 3 Months':
          final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
          matchesDate = transactionDate.isAfter(threeMonthsAgo);
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
              title: const Text('Transactions'),
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
                currentRoute: AppRoutes.transactionsRoute,
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
            SidebarMenu(currentRoute: AppRoutes.transactionsRoute),

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
                  // Header with title
                  _buildHeader(),

                  // Filter and search row
                  _buildFilterRow(),

                  // Transactions list
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildTransactionsList(),
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
                'Transactions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'View and manage all your financial transactions',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Export'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export functionality not implemented yet'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              // Search field
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filterStatus,
                    items: ['All', 'Completed', 'Pending', 'Refunded']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _filterStatus = newValue;
                        });
                      }
                    },
                    hint: const Text('Status'),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Date filter
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filterDate,
                    items: [
                      'All Time',
                      'Today',
                      'This Week',
                      'This Month',
                      'Last 3 Months'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _filterDate = newValue;
                        });
                      }
                    },
                    hint: const Text('Date'),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Summary row
          Row(
            children: [
              Text(
                'Showing ${filteredTransactions.length} transactions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              Text(
                'Total: RM ${_calculateTotal().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search criteria',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Transaction Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Customer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Service',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Amount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                child: Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 50), // Actions space
            ],
          ),
        ),

        // Transactions
        Expanded(
          child: ListView.separated(
            itemCount: filteredTransactions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final transaction = filteredTransactions[index];
              return _buildTransactionItem(transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final status = transaction['status'] as String;
    final statusColor = status == 'Completed'
        ? kCompletedColor
        : status == 'Pending'
            ? kPendingColor
            : Colors.red;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          // Transaction Details
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['id'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(transaction['date']),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      transaction['paymentMethod'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Customer
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['customerName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${transaction['customerId']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Service
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['serviceName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Booking ID: ${transaction['bookingId']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Expanded(
            child: Text(
              'RM ${transaction['amount'].toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == 'Refunded' ? Colors.red : Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          // Status
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Actions
          SizedBox(
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showTransactionActions(transaction);
              },
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionActions(Map<String, dynamic> transaction) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 16),
              SizedBox(width: 8),
              Text('View Details'),
            ],
          ),
        ),
        if (transaction['status'] == 'Pending')
          const PopupMenuItem(
            value: 'complete',
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16),
                SizedBox(width: 8),
                Text('Mark as Completed'),
              ],
            ),
          ),
        if (transaction['status'] == 'Completed')
          const PopupMenuItem(
            value: 'refund',
            child: Row(
              children: [
                Icon(Icons.money_off, size: 16),
                SizedBox(width: 8),
                Text('Process Refund'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'receipt',
          child: Row(
            children: [
              Icon(Icons.receipt, size: 16),
              SizedBox(width: 8),
              Text('Download Receipt'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;

      switch (value) {
        case 'view':
          // View transaction details
          _showTransactionDetails(transaction);
          break;
        case 'complete':
          // Mark as completed
          _updateTransactionStatus(transaction, 'Completed');
          break;
        case 'refund':
          // Process refund
          _updateTransactionStatus(transaction, 'Refunded');
          break;
        case 'receipt':
          // Download receipt
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Receipt download functionality not implemented'),
            ),
          );
          break;
      }
    });
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction ${transaction['id']}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Date',
                  DateFormat('MMMM d, yyyy').format(transaction['date'])),
              _buildDetailRow('Customer', transaction['customerName']),
              _buildDetailRow('Customer ID', transaction['customerId']),
              _buildDetailRow('Service', transaction['serviceName']),
              _buildDetailRow('Booking ID', transaction['bookingId']),
              _buildDetailRow(
                  'Amount', 'RM ${transaction['amount'].toStringAsFixed(2)}'),
              _buildDetailRow('Payment Method', transaction['paymentMethod']),
              _buildDetailRow('Status', transaction['status']),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('View Booking'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(
                context,
                AppRoutes.bookingDetailsRoute,
                arguments: transaction['bookingId'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
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
      ),
    );
  }

  void _updateTransactionStatus(
      Map<String, dynamic> transaction, String newStatus) {
    // In a real app, this would update the transaction status in the backend
    setState(() {
      for (var i = 0; i < _transactions.length; i++) {
        if (_transactions[i]['id'] == transaction['id']) {
          _transactions[i]['status'] = newStatus;
          break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction ${transaction['id']} marked as $newStatus'),
        backgroundColor: newStatus == 'Completed' ? Colors.green : Colors.blue,
      ),
    );
  }

  double _calculateTotal() {
    double total = 0;
    for (var transaction in filteredTransactions) {
      if (transaction['status'] != 'Refunded') {
        total += transaction['amount'];
      }
    }
    return total;
  }
}
