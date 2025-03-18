import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/services/auth_service.dart';
import 'package:provider/provider.dart';

class SidebarMenu extends StatefulWidget {
  final String currentRoute;
  final VoidCallback? onMenuItemSelected;

  const SidebarMenu({
    Key? key,
    required this.currentRoute,
    this.onMenuItemSelected,
  }) : super(key: key);

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  bool _isBookingsExpanded = false;
  bool _isServicesExpanded = false;
  bool _isFinancesExpanded = false;
  bool _isSettingsExpanded = false;

  @override
  void initState() {
    super.initState();

    // Set initial expansion states based on current route
    _isBookingsExpanded = widget.currentRoute.startsWith('/bookings');
    _isServicesExpanded = widget.currentRoute.startsWith('/services');
    _isFinancesExpanded = widget.currentRoute.startsWith('/finances');
    _isSettingsExpanded = widget.currentRoute.startsWith('/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    title: 'Dashboard',
                    icon: Icons.dashboard,
                    route: AppRoutes.dashboardRoute,
                  ),

                  // Bookings section
                  ExpansionTile(
                    initiallyExpanded: _isBookingsExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isBookingsExpanded = expanded;
                      });
                    },
                    title: _buildMenuItemContent(
                      title: 'Bookings',
                      icon: Icons.calendar_today,
                      isSelected: widget.currentRoute.startsWith('/bookings') ||
                          widget.currentRoute.startsWith('/calendar'),
                    ),
                    backgroundColor: Colors.grey.shade50,
                    collapsedBackgroundColor: Colors.white,
                    children: [
                      _buildSubmenuItem(
                        context,
                        title: 'All Bookings',
                        route: AppRoutes.bookingsRoute,
                      ),
                      _buildSubmenuItem(
                        context,
                        title: 'Calendar View',
                        route: AppRoutes.calendarRoute,
                      ),
                    ],
                  ),

                  // Services section
                  ExpansionTile(
                    initiallyExpanded: _isServicesExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isServicesExpanded = expanded;
                      });
                    },
                    title: _buildMenuItemContent(
                      title: 'Services',
                      icon: Icons.spa,
                      isSelected: widget.currentRoute.startsWith('/services'),
                    ),
                    backgroundColor: Colors.grey.shade50,
                    collapsedBackgroundColor: Colors.white,
                    children: [
                      _buildSubmenuItem(
                        context,
                        title: 'All Services',
                        route: AppRoutes.servicesRoute,
                      ),
                      _buildSubmenuItem(
                        context,
                        title: 'Add New Service',
                        route: AppRoutes.addServiceRoute,
                      ),
                    ],
                  ),

                  _buildMenuItem(
                    context,
                    title: 'Pets',
                    icon: Icons.pets,
                    route: AppRoutes.petsRoute,
                  ),

                  _buildMenuItem(
                    context,
                    title: 'Customers',
                    icon: Icons.people,
                    route: AppRoutes.customersRoute,
                  ),

                  _buildMenuItem(
                    context,
                    title: 'Messages',
                    icon: Icons.message,
                    route: AppRoutes.chatListRoute,
                  ),

                  // Finances section
                  ExpansionTile(
                    initiallyExpanded: _isFinancesExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isFinancesExpanded = expanded;
                      });
                    },
                    title: _buildMenuItemContent(
                      title: 'Finances',
                      icon: Icons.attach_money,
                      isSelected: widget.currentRoute.startsWith('/finances'),
                    ),
                    backgroundColor: Colors.grey.shade50,
                    collapsedBackgroundColor: Colors.white,
                    children: [
                      _buildSubmenuItem(
                        context,
                        title: 'Overview',
                        route: AppRoutes.financesRoute,
                      ),
                      _buildSubmenuItem(
                        context,
                        title: 'Transactions',
                        route: AppRoutes.transactionsRoute,
                      ),
                    ],
                  ),

                  _buildMenuItem(
                    context,
                    title: 'Analytics',
                    icon: Icons.insights,
                    route: AppRoutes.analyticsRoute,
                  ),

                  // Settings section
                  ExpansionTile(
                    initiallyExpanded: _isSettingsExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isSettingsExpanded = expanded;
                      });
                    },
                    title: _buildMenuItemContent(
                      title: 'Settings',
                      icon: Icons.settings,
                      isSelected: widget.currentRoute.startsWith('/settings'),
                    ),
                    backgroundColor: Colors.grey.shade50,
                    collapsedBackgroundColor: Colors.white,
                    children: [
                      _buildSubmenuItem(
                        context,
                        title: 'Business Profile',
                        route: AppRoutes.profileSettingsRoute,
                      ),
                      _buildSubmenuItem(
                        context,
                        title: 'Account Settings',
                        route: AppRoutes.userSettingsRoute,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: kPrimaryColor,
      height: 80,
      child: Row(
        children: [
          Image.asset(
            kLogoAsset,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'TOW',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'TOW Provider Portal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemContent({
    required String title,
    required IconData icon,
    bool isSelected = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isSelected ? kPrimaryColor : Colors.grey.shade700,
          size: 20,
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? kPrimaryColor : Colors.grey.shade900,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    final isSelected = widget.currentRoute == route;

    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.grey.shade50,
      leading: Icon(
        icon,
        color: isSelected ? kPrimaryColor : Colors.grey.shade700,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? kPrimaryColor : Colors.grey.shade900,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
        if (widget.onMenuItemSelected != null) {
          widget.onMenuItemSelected!();
        }
      },
    );
  }

  Widget _buildSubmenuItem(
    BuildContext context, {
    required String title,
    required String route,
  }) {
    final isSelected = widget.currentRoute == route;

    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.only(left: 48, right: 16),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? kPrimaryColor : Colors.grey.shade900,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
        if (widget.onMenuItemSelected != null) {
          widget.onMenuItemSelected!();
        }
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(
              Icons.person,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authService.currentUser?.displayName ?? 'User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  authService.currentUser?.email ?? 'user@example.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.grey.shade700,
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        authService.logout();
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.loginRoute);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
