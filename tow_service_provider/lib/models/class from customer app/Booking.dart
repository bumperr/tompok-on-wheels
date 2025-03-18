import 'package:flutter/material.dart';

class Booking {
  final String id;
  final String userId;
  final String petId;
  final String serviceProviderId;
  final String serviceId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final String status; // Pending, Confirmed, Completed, Cancelled
  final int days; // For boarding services
  final double totalPrice;
  final String notes;

  Booking({
    required this.id,
    required this.userId,
    required this.petId,
    required this.serviceProviderId,
    required this.serviceId,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.status,
    this.days = 1,
    required this.totalPrice,
    this.notes = '',
  });

  // From JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      petId: json['petId'],
      serviceProviderId: json['serviceProviderId'],
      serviceId: json['serviceId'],
      date: DateTime.parse(json['date']),
      startTime: _timeOfDayFromString(json['startTime']),
      endTime: json['endTime'] != null
          ? _timeOfDayFromString(json['endTime'])
          : null,
      status: json['status'],
      days: json['days'] ?? 1,
      totalPrice: json['totalPrice'].toDouble(),
      notes: json['notes'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'petId': petId,
      'serviceProviderId': serviceProviderId,
      'serviceId': serviceId,
      'date': date.toIso8601String(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'status': status,
      'days': days,
      'totalPrice': totalPrice,
      'notes': notes,
    };
  }

  static TimeOfDay _timeOfDayFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
