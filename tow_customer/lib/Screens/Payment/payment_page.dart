import 'package:flutter/material.dart';
import 'package:tow_customer/constants.dart';
import 'dart:async';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  final double totalAmount;

  const PaymentPage({
    Key? key,
    required this.bookingDetails,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _currentStep = 0;
  bool _isProcessing = false;
  String _selectedPaymentMethod = 'Credit Card';

  // Payment methods available in Malaysia
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'brands': ['Visa', 'Mastercard', 'American Express']
    },
    {
      'name': 'Online Banking',
      'icon': Icons.account_balance,
      'brands': ['Maybank2u', 'CIMB Clicks', 'Public Bank', 'RHB Now']
    },
    {
      'name': 'E-Wallet',
      'icon': Icons.account_balance_wallet,
      'brands': ['Touch n Go eWallet', 'Boost', 'GrabPay', 'MAE']
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _continue,
        onStepCancel: _cancel,
        steps: [
          Step(
            title: const Text('Select Payment Method'),
            content: Column(
              children: _paymentMethods.map((method) {
                return RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(method['icon'], color: kPrimaryColor),
                      const SizedBox(width: 10),
                      Text(method['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  subtitle: Wrap(
                    spacing: 8,
                    children: (method['brands'] as List<String>).map((brand) {
                      return Chip(
                        label:
                            Text(brand, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
                  ),
                  value: method['name'],
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  activeColor: kPrimaryColor,
                );
              }).toList(),
            ),
            isActive: _currentStep == 0,
          ),
          Step(
            title: Text('Enter $_selectedPaymentMethod Details'),
            content: _buildPaymentDetailsForm(),
            isActive: _currentStep == 1,
          ),
          Step(
            title: const Text('Confirm Payment'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 20),
                if (_isProcessing)
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: kPrimaryColor),
                        SizedBox(height: 16),
                        Text('Processing payment...'),
                      ],
                    ),
                  ),
              ],
            ),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsForm() {
    if (_selectedPaymentMethod == 'Credit Card') {
      return Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Card Number',
              hintText: '4111 1111 1111 1111',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name on Card',
              hintText: 'JOHN DOE',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    } else if (_selectedPaymentMethod == 'Online Banking') {
      return Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select Bank',
              border: OutlineInputBorder(),
            ),
            items: [
              'Maybank2u',
              'CIMB Clicks',
              'Public Bank',
              'RHB Now',
              'Hong Leong Connect',
              'AmOnline'
            ].map((bank) {
              return DropdownMenuItem<String>(
                value: bank,
                child: Text(bank),
              );
            }).toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'You will be redirected to your online banking portal to complete the payment.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    } else {
      // E-Wallet
      return Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select E-Wallet',
              border: OutlineInputBorder(),
            ),
            items: [
              'Touch n Go eWallet',
              'Boost',
              'GrabPay',
              'MAE',
              'ShopeePay',
              'BigPay'
            ].map((wallet) {
              return DropdownMenuItem<String>(
                value: wallet,
                child: Text(wallet),
              );
            }).toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              hintText: '01X-XXX XXXX',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'You will receive a notification on your e-wallet app to complete the payment.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Service'),
                Text(widget.bookingDetails['service']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Provider'),
                Text(widget.bookingDetails['provider']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Date & Time'),
                Text(
                    '${widget.bookingDetails['date']} - ${widget.bookingDetails['time']}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount'),
                Text('RM ${widget.totalAmount.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method'),
                Text(_selectedPaymentMethod),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _processPayment();
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing delay
    Timer(const Duration(seconds: 5), () {
      Navigator.pop(
          context, true); // Return true to indicate successful payment
    });
  }
}
