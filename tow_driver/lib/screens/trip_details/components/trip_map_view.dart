// lib/screens/trip_details/components/trip_map_view.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tow_driver/class/trip.dart';

class TripMapView extends StatefulWidget {
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;
  final LatLng driverLatLng;
  final TripStatus tripStatus;

  const TripMapView({
    Key? key,
    required this.pickupLatLng,
    required this.destinationLatLng,
    required this.driverLatLng,
    required this.tripStatus,
  }) : super(key: key);

  @override
  _TripMapViewState createState() => _TripMapViewState();
}

class _TripMapViewState extends State<TripMapView> {
  //late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.driverLatLng, // Center map on driver's current location
        zoom: 14,
      ),
      markers: {
        // Driver location marker
        Marker(
          markerId: const MarkerId('driver_location'),
          position: widget.driverLatLng,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
        // Pickup location marker
        Marker(
          markerId: const MarkerId('pickup_location'),
          position: widget.pickupLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
        // Destination location marker
        Marker(
          markerId: const MarkerId('destination_location'),
          position: widget.destinationLatLng,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      },
      polylines: {
        // Polyline from driver to pickup (if en route to pickup)
        if (widget.tripStatus == TripStatus.enRouteToPickup ||
            widget.tripStatus == TripStatus.accepted)
          Polyline(
            polylineId: const PolylineId('driver_to_pickup'),
            points: [widget.driverLatLng, widget.pickupLatLng],
            color: Colors.blue,
            width: 5,
          ),
        // Polyline from pickup to destination (if in transit)
        if (widget.tripStatus == TripStatus.inProgress)
          Polyline(
            polylineId: const PolylineId('pickup_to_destination'),
            points: [widget.pickupLatLng, widget.destinationLatLng],
            color: Colors.blue,
            width: 5,
          ),
        // Polyline showing the full route
        Polyline(
          polylineId: const PolylineId('full_route'),
          points: [widget.pickupLatLng, widget.destinationLatLng],
          color: Colors.grey.withOpacity(0.5),
          width: 3,
          patterns: [PatternItem.dot, PatternItem.gap(10)],
        ),
      },
      onMapCreated: (controller) {
        //_mapController = controller;
      },
      // Enable map interactions
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
