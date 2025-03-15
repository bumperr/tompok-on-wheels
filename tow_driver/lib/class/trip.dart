// lib/class/trip.dart
import 'package:flutter/material.dart';

enum TripStatus {
  pending,
  accepted,
  enRouteToPickup,
  arrived,
  inProgress,
  completed,
  cancelled
}

class Trip {
  final String id;
  final String driverId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String petId;
  final String petName;
  final String petBreed;
  final int petAge;
  final String petImageUrl;
  final String serviceProviderId;
  final String serviceProviderName;
  final String serviceId;
  final String serviceName;
  final String pickupAddress;
  final String pickupLatitude;
  final String pickupLongitude;
  final String destinationAddress;
  final String destinationLatitude;
  final String destinationLongitude;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final TripStatus status;
  final double distance; // in kilometers
  final double duration; // in minutes
  final double fare;
  final double driverEarnings;
  final List<String> specialInstructions;
  final bool isPaid;
  final bool isRated;
  
  Trip({
    required this.id,
    required this.driverId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.petId,
    required this.petName,
    required this.petBreed,
    required this.petAge,
    required this.petImageUrl,
    required this.serviceProviderId,
    required this.serviceProviderName,
    required this.serviceId,
    required this.serviceName,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationAddress,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.driverEarnings,
    this.specialInstructions = const [],
    this.isPaid = false,
    this.isRated = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'petId': petId,
      'petName': petName,
      'petBreed': petBreed,
      'petAge': petAge,
      'petImageUrl': petImageUrl,
      'serviceProviderId': serviceProviderId,
      'serviceProviderName': serviceProviderName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'pickupAddress': pickupAddress,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'destinationAddress': destinationAddress,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'date': date.toIso8601String(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'status': status.toString(),
      'distance': distance,
      'duration': duration,
      'fare': fare,
      'driverEarnings': driverEarnings,
      'specialInstructions': specialInstructions,
      'isPaid': isPaid,
      'isRated': isRated,
    };
  }
  
  static TimeOfDay _timeOfDayFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      driverId: json['driverId'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      petId: json['petId'],
      petName: json['petName'],
      petBreed: json['petBreed'],
      petAge: json['petAge'],
      petImageUrl: json['petImageUrl'],
      serviceProviderId: json['serviceProviderId'],
      serviceProviderName: json['serviceProviderName'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      pickupAddress: json['pickupAddress'],
      pickupLatitude: json['pickupLatitude'],
      pickupLongitude: json['pickupLongitude'],
      destinationAddress: json['destinationAddress'],
      destinationLatitude: json['destinationLatitude'],
      destinationLongitude: json['destinationLongitude'],
      date: DateTime.parse(json['date']),
      startTime: _timeOfDayFromString(json['startTime']),
      endTime: json['endTime'] != null ? _timeOfDayFromString(json['endTime']) : null,
      status: TripStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => TripStatus.pending,
      ),
      distance: json['distance'],
      duration: json['duration'],
      fare: json['fare'],
      driverEarnings: json['driverEarnings'],
      specialInstructions: List<String>.from(json['specialInstructions'] ?? []),
      isPaid: json['isPaid'] ?? false,
      isRated: json['isRated'] ?? false,
    );
  }
}