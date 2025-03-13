import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:tow_customer/class/User.dart';

class ServiceProvider {
  final String id;
  final String name;
  final String category;
  final String logoUrl;
  final bool isVerified;
  final double? rating;
  double? distance;
  int? travelTime;
  final String? latitude;
  final String? longitude;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.category,
    required this.logoUrl,
    required this.isVerified,
    this.rating,
    this.distance,
    this.travelTime,
    this.latitude,
    this.longitude,
  });

  LatLng? get coordinates => latitude != null && longitude != null
      ? LatLng(double.parse(latitude!), double.parse(longitude!))
      : null;

  // Calculate straight-line distance (in km) as a fallback method
  double calculateStraightLineDistance(LatLng userCoordinates) {
    if (coordinates == null) return 0;

    final double lat1 = userCoordinates.latitude;
    final double lon1 = userCoordinates.longitude;
    final double lat2 = coordinates!.latitude;
    final double lon2 = coordinates!.longitude;

    const int earthRadius = 6371; // Radius of the earth in km

    final double latDistance = _toRadians(lat2 - lat1);
    final double lonDistance = _toRadians(lon2 - lon1);

    final double a = math.sin(latDistance / 2) * math.sin(latDistance / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(lonDistance / 2) *
            math.sin(lonDistance / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return double.parse((earthRadius * c)
        .toStringAsFixed(1)); // Distance in km, rounded to 1 decimal place
  }

  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }

  // Method to update distance and travel time using Google Maps API
  Future<void> updateDistanceAndTravelTime(User user, String apiKey) async {
    if (coordinates == null) {
      distance = calculateStraightLineDistance(user.coordinates);
      travelTime = (distance! * 3).round();
      return;
    }

    try {
      final String url =
          'https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix';

      final headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask':
            'originIndex,destinationIndex,distanceMeters,duration,status', // Added required FieldMask
      };

      final body = json.encode({
        'origins': [
          {
            'waypoint': {
              'location': {
                'latLng': {
                  'latitude': user.coordinates.latitude,
                  'longitude': user.coordinates.longitude,
                },
              },
            },
          },
        ],
        'destinations': [
          {
            'waypoint': {
              'location': {
                'latLng': {
                  'latitude': coordinates!.latitude,
                  'longitude': coordinates!.longitude,
                },
              },
            },
          },
        ],
        'travelMode': 'DRIVE',
      });

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0]['status']['code'] == null) {
          // Check status is OK (no error code)
          final element = data[0];

          // Get distance in kilometers
          final distanceValue =
              element['distanceMeters'] / 1000; // Convert meters to km
          distance = double.parse(distanceValue.toStringAsFixed(1));

          // Get travel time in minutes
          final durationValue =
              int.parse(element['duration'].replaceAll('s', '')) /
                  60; // Convert seconds to minutes
          travelTime = durationValue.round();
        } else {
          distance = calculateStraightLineDistance(user.coordinates);
          travelTime = (distance! * 3).round();
        }
      } else {
        distance = calculateStraightLineDistance(user.coordinates);
        travelTime = (distance! * 3).round();
      }
    } catch (e) {
      distance = calculateStraightLineDistance(user.coordinates);
      travelTime = (distance! * 3).round();
    }
  }

  // Create a copy of this service provider with updated distance and travel time
  ServiceProvider copyWith({
    double? distance,
    int? travelTime,
  }) {
    return ServiceProvider(
      id: id,
      name: name,
      category: category,
      logoUrl: logoUrl,
      isVerified: isVerified,
      rating: rating,
      distance: distance ?? this.distance,
      travelTime: travelTime ?? this.travelTime,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
