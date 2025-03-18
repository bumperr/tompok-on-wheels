
// lib/class/transaction.dart
enum TransactionType {
  tripPayment,
  bonus,
  fee,
  withdrawal,
  refund
}

class Transaction {
  final String id;
  final String driverId;
  final String? tripId;
  final TransactionType type;
  final double amount;
  final DateTime timestamp;
  final String description;
  final bool isCompleted;
  
  Transaction({
    required this.id,
    required this.driverId,
    this.tripId,
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.description,
    this.isCompleted = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'tripId': tripId,
      'type': type.toString(),
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'isCompleted': isCompleted,
    };
  }
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      driverId: json['driverId'],
      tripId: json['tripId'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TransactionType.tripPayment,
      ),
      amount: json['amount'],
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}