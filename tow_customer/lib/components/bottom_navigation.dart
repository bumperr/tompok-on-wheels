import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FlashyTabBar(
      animationCurve: Curves.easeInOut,
      selectedIndex: selectedIndex,
      showElevation: true,
      onItemSelected: onItemSelected,
      items: [
        FlashyTabBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.store),
          title: Text('Services'),
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Bookings'),
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
      ],
    );
  }
}
