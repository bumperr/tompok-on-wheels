// lib/screens/home/home.dart
import 'package:flutter/material.dart';
//import 'package:tow_driver/constants.dart';
import 'package:tow_driver/data/sample_data.dart';
import 'package:tow_driver/components/bottom_navigation.dart';
import 'package:tow_driver/screens/home/components/driver_header.dart';
//import 'package:tow_driver/screens/home/components/earnings_summary.dart';
import 'package:tow_driver/screens/home/components/trip_status_card.dart';
import 'package:tow_driver/screens/home/components/upcoming_trips.dart';
import 'package:tow_driver/screens/trips/trips_page.dart';
import 'package:tow_driver/screens/wallet/wallet_page.dart';
import 'package:tow_driver/screens/profile/profile_page.dart';
import 'package:tow_driver/screens/trip_details/trip_details_screen.dart';
import 'package:tow_driver/class/trip.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isOnline = true;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create pages list inside build method to access the current state
    final List<Widget> pages = [
      HomeContent(
        driver: sampleDriver,
        isOnline: _isOnline,
        onToggleStatus: _toggleOnlineStatus,
      ),
      TripsPage(trips: sampleTrips),
      WalletPage(
        driver: sampleDriver,
        transactions: sampleTransactions,
      ),
      ProfilePage(driver: sampleDriver),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: DriverBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final driver;
  final bool isOnline;
  final VoidCallback onToggleStatus;

  const HomeContent({
    Key? key,
    required this.driver,
    required this.isOnline,
    required this.onToggleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current trip if any
    final currentTrip = sampleTrips.firstWhere(
      (trip) => trip.status == TripStatus.inProgress,
      orElse: () => sampleTrips.firstWhere(
        (trip) => trip.status == TripStatus.accepted,
        orElse: () => sampleTrips.first,
      ),
    );

    // Get upcoming trips
    final upcomingTrips = sampleTrips
        .where((trip) => trip.status == TripStatus.pending || trip.status == TripStatus.accepted)
        .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DriverHeader(
                driver: driver,
                isOnline: isOnline,
                onToggleStatus: onToggleStatus,
              ),
            ),
            
            const SizedBox(height: 24),
            
            
            
            // Current Trip Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TripStatusCard(
                trip: currentTrip,
                onViewDetails: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsScreen(
                        trip: currentTrip,
                        checklist: samplePetChecklist,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Upcoming Trips Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Upcoming Trips",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Switch to Trips tab
                      _onItemSelected(1);
                    },
                    child: const Text("See All"),
                  ),
                ],
              ),
            ),
            
            UpcomingTrips(
              trips: upcomingTrips,
              onTripTap: (trip) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetailsScreen(
                      trip: trip,
                      checklist: samplePetChecklist,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemSelected(int index) {
    // This is just a placeholder since we can't directly access the parent's setState
    // In a real app, this would be handled through a state management solution like Provider
  }
}