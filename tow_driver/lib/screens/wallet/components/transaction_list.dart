
// lib/screens/wallet/components/transaction_list.dart
import 'package:flutter/material.dart';
import 'package:tow_driver/class/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onTransactionTap;

  const TransactionList({
    Key? key,
    required this.transactions,
    required this.onTransactionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Group transactions by date
    final groupedTransactions = _groupTransactionsByDate();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateGroup = groupedTransactions.keys.elementAt(index);
        final transactionsInGroup = groupedTransactions[dateGroup]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                dateGroup,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ...transactionsInGroup.map((transaction) => 
              _buildTransactionItem(context, transaction),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate() {
    final grouped = <String, List<Transaction>>{};
    
    for (final transaction in transactions) {
      final date = DateFormat('MMMM d, yyyy').format(transaction.timestamp);
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      
      grouped[date]!.add(transaction);
    }
    
    // Sort dates in descending order (newest first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => DateFormat('MMMM d, yyyy').parse(b)
          .compareTo(DateFormat('MMMM d, yyyy').parse(a)));
    
    // Create a new map with sorted keys
    final sortedGrouped = <String, List<Transaction>>{};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }
    
    return sortedGrouped;
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final isPositive = transaction.amount > 0;
    final formattedAmount = 'RM ${transaction.amount.abs().toStringAsFixed(2)}';
    final formattedTime = DateFormat('h:mm a').format(transaction.timestamp);
    
    return InkWell(
      onTap: () => onTransactionTap(transaction),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Transaction type icon
            CircleAvatar(
              backgroundColor: _getTransactionColor(transaction.type).withOpacity(0.2),
              child: Icon(
                _getTransactionIcon(transaction.type),
                color: _getTransactionColor(transaction.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTransactionTitle(transaction.type),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Amount and time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isPositive ? '+$formattedAmount' : '-$formattedAmount',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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