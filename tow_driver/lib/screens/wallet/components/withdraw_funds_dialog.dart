
// lib/screens/wallet/components/withdraw_funds_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tow_driver/constants.dart';

class WithdrawFundsDialog extends StatefulWidget {
  final double availableBalance;
  final Function(double) onWithdraw;

  const WithdrawFundsDialog({
    Key? key,
    required this.availableBalance,
    required this.onWithdraw,
  }) : super(key: key);

  @override
  _WithdrawFundsDialogState createState() => _WithdrawFundsDialogState();
}

class _WithdrawFundsDialogState extends State<WithdrawFundsDialog> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedBankIndex = 0;
  bool _isProcessing = false;
  String? _errorText;
  
  final List<Map<String, dynamic>> _banks = [
    {
      'name': 'Maybank',
      'icon': 'assets/icons/maybank.png',
      'accountNumber': '**** 1234',
    },
    {
      'name': 'CIMB',
      'icon': 'assets/icons/cimb.png',
      'accountNumber': '**** 5678',
    },
    {
      'name': 'Public Bank',
      'icon': 'assets/icons/public_bank.png',
      'accountNumber': '**** 9012',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateAmount(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorText = null;
      });
      return;
    }
    
    try {
      final amount = double.parse(value);
      if (amount <= 0) {
        setState(() {
          _errorText = 'Amount must be greater than 0';
        });
      } else if (amount > widget.availableBalance) {
        setState(() {
          _errorText = 'Amount exceeds available balance';
        });
      } else {
        setState(() {
          _errorText = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Please enter a valid amount';
      });
    }
  }

  void _handleWithdraw() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _errorText = 'Please enter an amount';
      });
      return;
    }
    
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorText = 'Please enter a valid amount';
      });
      return;
    }
    
    if (amount > widget.availableBalance) {
      setState(() {
        _errorText = 'Amount exceeds available balance';
      });
      return;
    }
    
    // Simulate processing
    setState(() {
      _isProcessing = true;
    });
    
    // In a real app, this would call an API
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });
      
      // Close dialog and call callback
      Navigator.pop(context);
      widget.onWithdraw(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Withdraw Funds',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Available balance
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'RM ${widget.availableBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Amount input
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount (RM)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                errorText: _errorText,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: _validateAmount,
            ),
            const SizedBox(height: 16),
            // Quick amount buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAmountButton(50),
                _buildQuickAmountButton(100),
                _buildQuickAmountButton(200),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _amountController.text = widget.availableBalance.toStringAsFixed(2);
                    _validateAmount(_amountController.text);
                  },
                  child: const Text('Max'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Bank selection
            const Text(
              'Select Bank Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            // Placeholder for bank selection - in a real app, this would fetch from the user's saved bank accounts
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _banks.length,
                itemBuilder: (context, index) => _buildBankOption(index),
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _isProcessing ? null : _handleWithdraw,
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Withdraw'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButton(double amount) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        _amountController.text = amount.toStringAsFixed(2);
        _validateAmount(_amountController.text);
      },
      child: Text('RM$amount'),
    );
  }

  Widget _buildBankOption(int index) {
    final bank = _banks[index];
    final isSelected = index == _selectedBankIndex;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBankIndex = index;
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // In a real app, this would be an actual bank icon
            Icon(
              Icons.account_balance,
              color: isSelected ? kPrimaryColor : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              bank['name'],
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? kPrimaryColor : Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}