import 'package:flutter/material.dart';
import 'package:tow_service_provider/screens/auth/login_screen.dart';
import 'package:tow_service_provider/screens/auth/register_screen.dart';
import 'package:tow_service_provider/screens/dashboard/dashboard_screen.dart';
import 'package:tow_service_provider/screens/dashboard/analytics_screen.dart';
import 'package:tow_service_provider/screens/bookings/bookings_screen.dart';
import 'package:tow_service_provider/screens/bookings/booking_details.dart';
//import 'package:tow_service_provider/screens/bookings/calendar_view.dart';
import 'package:tow_service_provider/screens/service/services_screen.dart';
import 'package:tow_service_provider/screens/service/service_form.dart';
import 'package:tow_service_provider/screens/pets/pets_screen.dart';
import 'package:tow_service_provider/screens/pets/pet_details.dart';
import 'package:tow_service_provider/screens/customers/customers_screen.dart';
// import 'package:tow_service_provider/screens/customers/customer_details.dart';
// import 'package:tow_service_provider/screens/chat/chat_list.dart';
// import 'package:tow_service_provider/screens/chat/chat_screen.dart';
// import 'package:tow_service_provider/screens/finances/finances_screen.dart';
// import 'package:tow_service_provider/screens/finances/transactions.dart';
// import 'package:tow_service_provider/screens/settings/settings_screen.dart';
// import 'package:tow_service_provider/screens/settings/profile_settings.dart';
// import 'package:tow_service_provider/screens/settings/user_settings.dart';

class AppRoutes {
  // Auth Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';

  // Main Routes
  static const String dashboardRoute = '/dashboard';
  static const String analyticsRoute = '/analytics';

  // Booking Routes
  static const String bookingsRoute = '/bookings';
  static const String bookingDetailsRoute = '/bookings/details';
  static const String calendarRoute = '/bookings/calendar';

  // Service Routes
  static const String servicesRoute = '/services';
  static const String addServiceRoute = '/services/add';
  static const String editServiceRoute = '/services/edit';

  // Pet Routes
  static const String petsRoute = '/pets';
  static const String petDetailsRoute = '/pets/details';

  // Customer Routes
  static const String customersRoute = '/customers';
  static const String customerDetailsRoute = '/customers/details';

  // Chat Routes
  static const String chatListRoute = '/chats';
  static const String chatRoute = '/chats/conversation';

  // Finance Routes
  static const String financesRoute = '/finances';
  static const String transactionsRoute = '/finances/transactions';

  // Settings Routes
  static const String settingsRoute = '/settings';
  static const String profileSettingsRoute = '/settings/profile';
  static const String userSettingsRoute = '/settings/user';

  // Define all routes here
  static final Map<String, WidgetBuilder> routes = {
    loginRoute: (context) => const LoginScreen(),
    registerRoute: (context) => const RegisterScreen(),
    dashboardRoute: (context) => const DashboardScreen(),
    analyticsRoute: (context) => const AnalyticsScreen(),
    bookingsRoute: (context) => const BookingsScreen(),
    bookingDetailsRoute: (context) => const BookingDetails(),
    //calendarRoute: (context) => const CalendarView(),
    servicesRoute: (context) => const ServicesScreen(),
    addServiceRoute: (context) => const ServiceForm(isEditing: false),
    editServiceRoute: (context) => const ServiceForm(isEditing: true),
    petsRoute: (context) => const PetsScreen(),
    petDetailsRoute: (context) => const PetDetails(),
    customersRoute: (context) => const CustomersScreen(),
    // customerDetailsRoute: (context) => const CustomerDetails(),
    // chatListRoute: (context) => const ChatList(),
    // chatRoute: (context) => const ChatScreen(),
    // financesRoute: (context) => const FinancesScreen(),
    // transactionsRoute: (context) => const TransactionsScreen(),
    // settingsRoute: (context) => const SettingsScreen(),
    // profileSettingsRoute: (context) => const ProfileSettings(),
    // userSettingsRoute: (context) => const UserSettings(),
  };
}
