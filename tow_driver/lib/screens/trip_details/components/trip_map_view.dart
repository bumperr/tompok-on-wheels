// lib/screens/trip_details/components/trip_map_view.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tow_driver/class/trip.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

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
  // custom marker
  late BitmapDescriptor _userMarker;
  late BitmapDescriptor _storeMarker;
  late BitmapDescriptor _driverMarker;

  // ignore: unused_field
  bool _isMarkersInitialized = false;

  //initialize the marker
  Future<BitmapDescriptor> getResizedMarker(String assetPath, int width) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width, // Set desired width (height auto scales)
    );
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List resizedImageBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedImageBytes);
  }

  Future<void> _initCustomMarkers() async {
    _userMarker = await getResizedMarker('assets/markers/user_marker.png', 100);
    _storeMarker =
        await getResizedMarker('assets/markers/store_marker.png', 100);
    _driverMarker =
        await getResizedMarker('assets/markers/driver_marker.png', 100);
    setState(() {
      _isMarkersInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _initCustomMarkers();
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
          icon: _driverMarker,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
        // Pickup location marker
        Marker(
          markerId: const MarkerId('pickup_location'),
          position: widget.pickupLatLng,
          icon: _storeMarker,
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
        // Destination location marker
        Marker(
          markerId: const MarkerId('destination_location'),
          position: widget.destinationLatLng,
          icon: _userMarker,
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
