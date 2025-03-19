// lib/screens/wallet/wallet_page.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/constants.dart';
import 'package:tow_driver/class/driver.dart';
import 'package:tow_driver/class/transaction.dart';
import 'package:tow_driver/screens/wallet/components/earnings_card.dart';
import 'package:tow_driver/screens/wallet/components/transaction_list.dart';
//import 'package:tow_driver/screens/wallet/components/withdraw_funds_dialog.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  final Driver driver;
  final List<Transaction> transactions;

  const WalletPage({
    Key? key,
    required this.driver,
    required this.transactions,
  }) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Earnings', 'Withdrawals'];

  // Transaction filter state
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Transaction> _filterTransactions(String filter) {
    switch (filter) {
      case 'Earnings':
        return widget.transactions
            .where((transaction) =>
                transaction.type == TransactionType.tripPayment ||
                transaction.type == TransactionType.bonus)
            .toList();
      case 'Withdrawals':
        return widget.transactions
            .where(
                (transaction) => transaction.type == TransactionType.withdrawal)
            .toList();
      default:
        return widget.transactions;
    }
  }

  void _showWithdrawDialog() {
    final TextEditingController amountController = TextEditingController();
    final availableBalance = widget.driver.earnings;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available Balance: RM${availableBalance.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: 'RM',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              if (amount > availableBalance) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Insufficient balance'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Navigator.pop(context);

              // In a real app, this would call an API to withdraw funds
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Withdrawal request of RM${amount.toStringAsFixed(2)} submitted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('WITHDRAW'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _tabs.map((label) => Tab(text: label)).toList(),
          onTap: (index) {
            setState(() {
              _selectedFilter = _tabs[index];
            });
          },
        ),
      ),
      body: Column(
        children: [
          // Earnings summary card
          EarningsCard(
            availableBalance: widget.driver.earnings,
            weeklyEarnings: _calculateWeeklyEarnings(),
            onWithdraw: _showWithdrawDialog,
          ),

          // Transactions list
          Expanded(
            child: TransactionList(
              transactions: _filterTransactions(_selectedFilter),
              onTransactionTap: _showTransactionDetails,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateWeeklyEarnings() {
    // Calculate earnings for the current week
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return widget.transactions
        .where((transaction) =>
            (transaction.type == TransactionType.tripPayment ||
                transaction.type == TransactionType.bonus) &&
            transaction.timestamp.isAfter(startOfWeekDate))
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildTransactionDetails(transaction),
    );
  }

  Widget _buildTransactionDetails(Transaction transaction) {
    // Format date for display
    final formattedDate =
        DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(transaction.timestamp);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    _getTransactionColor(transaction.type).withOpacity(0.2),
                child: Icon(
                  _getTransactionIcon(transaction.type),
                  color: _getTransactionColor(transaction.type),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTransactionTitle(transaction.type),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          const Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
              'Transaction ID', '#${transaction.id.substring(0, 8)}'),
          const SizedBox(height: 8),
          _buildDetailRow(
              'Amount', 'RM ${transaction.amount.abs().toStringAsFixed(2)}',
              valueColor: transaction.amount > 0 ? Colors.green : Colors.red),
          const SizedBox(height: 8),
          _buildDetailRow(
              'Status', transaction.isCompleted ? 'Completed' : 'Pending',
              valueColor:
                  transaction.isCompleted ? Colors.green : Colors.orange),
          const SizedBox(height: 8),
          _buildDetailRow('Description', transaction.description),
          if (transaction.tripId != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.visibility),
              label: const Text('View Trip Details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: kPrimaryColor,
                side: BorderSide(color: kPrimaryColor),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Navigate to trip details
                Navigator.pop(context); // Close the modal first
                // In a real app, this would navigate to the trip details screen
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.tripPayment:
        return Colors.green;
      case TransactionType.bonus:
        return Colors.purple;
      case TransactionType.fee:
        return Colors.orange;
      case TransactionType.withdrawal:
        return Colors.red;
      case TransactionType.refund:
        return Colors.blue;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.tripPayment:
        return Icons.directions_car;
      case TransactionType.bonus:
        return Icons.card_giftcard;
      case TransactionType.fee:
        return Icons.attach_money;
      case TransactionType.withdrawal:
        return Icons.account_balance;
      case TransactionType.refund:
        return Icons.replay;
    }
  }

  String _getTransactionTitle(TransactionType type) {
    switch (type) {
      case TransactionType.tripPayment:
        return 'Trip Payment';
      case TransactionType.bonus:
        return 'Bonus';
      case TransactionType.fee:
        return 'Service Fee';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.refund:
        return 'Refund';
    }
  }
}
