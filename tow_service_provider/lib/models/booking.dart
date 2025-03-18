import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum BookingStatus {
  pending,
  confirmed,
  inTransit,
  inProgress,
  completed,
  cancelled,
  noShow
}

class Booking {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String petId;
  final String petName;
  final String petType;
  final String petBreed;
  final int petAge;
  final String petImageUrl;
  final String providerId;
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final BookingStatus status;
  final bool needsTransportation;
  final double totalPrice;
  final String notes;
  final List<String> specialInstructions;
  final DateTime createdAt;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final bool isPaid;

  Booking({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.petId,
    required this.petName,
    required this.petType,
    required this.petBreed,
    required this.petAge,
    required this.petImageUrl,
    required this.providerId,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.status,
    this.needsTransportation = false,
    required this.totalPrice,
    this.notes = '',
    this.specialInstructions = const [],
    DateTime? createdAt,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.isPaid = false,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Create a copy with updated fields
  Booking copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? petId,
    String? petName,
    String? petType,
    String? petBreed,
    int? petAge,
    String? petImageUrl,
    String? providerId,
    String? serviceId,
    String? serviceName,
    double? servicePrice,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    BookingStatus? status,
    bool? needsTransportation,
    double? totalPrice,
    String? notes,
    List<String>? specialInstructions,
    DateTime? createdAt,
    String? driverId,
    String? driverName,
    String? driverPhone,
    bool? isPaid,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      petId: petId ?? this.petId,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      petBreed: petBreed ?? this.petBreed,
      petAge: petAge ?? this.petAge,
      petImageUrl: petImageUrl ?? this.petImageUrl,
      providerId: providerId ?? this.providerId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      needsTransportation: needsTransportation ?? this.needsTransportation,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  // Helper method to format time
  static String _timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper method to parse time string
  static TimeOfDay _timeOfDayFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'petId': petId,
      'petName': petName,
      'petType': petType,
      'petBreed': petBreed,
      'petAge': petAge,
      'petImageUrl': petImageUrl,
      'providerId': providerId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'date': date.toIso8601String(),
      'startTime': _timeOfDayToString(startTime),
      'endTime': endTime != null ? _timeOfDayToString(endTime!) : null,
      'status': status.toString().split('.').last,
      'needsTransportation': needsTransportation,
      'totalPrice': totalPrice,
      'notes': notes,
      'specialInstructions': specialInstructions,
      'createdAt': createdAt.toIso8601String(),
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'isPaid': isPaid,
    };
  }

  // Create from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      petId: json['petId'],
      petName: json['petName'],
      petType: json['petType'],
      petBreed: json['petBreed'],
      petAge: json['petAge'],
      petImageUrl: json['petImageUrl'],
      providerId: json['providerId'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      servicePrice: json['servicePrice'].toDouble(),
      date: DateTime.parse(json['date']),
      startTime: _timeOfDayFromString(json['startTime']),
      endTime: json['endTime'] != null
          ? _timeOfDayFromString(json['endTime'])
          : null,
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      needsTransportation: json['needsTransportation'] ?? false,
      totalPrice: json['totalPrice'].toDouble(),
      notes: json['notes'] ?? '',
      specialInstructions: List<String>.from(json['specialInstructions'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      isPaid: json['isPaid'] ?? false,
    );
  }

  // Get color for booking status
  Color getStatusColor() {
    switch (status) {
      case BookingStatus.pending:
        return const Color(0xFFFF9800); // Orange
      case BookingStatus.confirmed:
        return const Color(0xFF4CAF50); // Green
      case BookingStatus.inTransit:
        return const Color(0xFF2196F3); // Blue
      case BookingStatus.inProgress:
        return const Color(0xFF9C27B0); // Purple
      case BookingStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case BookingStatus.cancelled:
        return const Color(0xFFE53935); // Red
      case BookingStatus.noShow:
        return const Color(0xFF607D8B); // Blue Grey
    }
  }

  // Get text for booking status
  String getStatusText() {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inTransit:
        return 'In Transit';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.noShow:
        return 'No Show';
    }
  }

  // Format date and time for display
  String get formattedDateTime {
    final now = DateTime.now();
    final dateFormat = now.year == date.year
        ? DateFormat('EEE, MMM d') // Same year
        : DateFormat('EEE, MMM d, yyyy'); // Different year

    final formattedDate = dateFormat.format(date);
    final formattedTime = DateFormat('h:mm a').format(
      DateTime(0, 0, 0, startTime.hour, startTime.minute),
    );

    return '$formattedDate at $formattedTime';
  }

  // Check if the booking is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if booking is upcoming (in the future)
  bool get isUpcoming {
    return date.isAfter(DateTime.now());
  }

  // Get readable duration for the booking
  String get formattedDuration {
    if (endTime == null) return 'N/A';

    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime!.hour * 60 + endTime!.minute;
    final totalMinutes = endMinutes - startMinutes;

    if (totalMinutes < 60) {
      return '$totalMinutes min';
    } else {
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      if (minutes == 0) {
        return '$hours hr';
      } else {
        return '$hours hr $minutes min';
      }
    }
  }
}
