import 'package:flutter/material.dart';
import 'package:tow_service_provider/constants.dart';
import 'package:tow_service_provider/routes.dart';
import 'package:tow_service_provider/screens/auth/login_screen.dart';
import 'package:tow_service_provider/screens/dashboard/dashboard_screen.dart';
import 'package:tow_service_provider/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Remove the # from the URL
  setPathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const TowProviderApp(),
    ),
  );
}

class TowProviderApp extends StatelessWidget {
  const TowProviderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOW Service Provider Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: kPrimaryColor,
          secondary: kAccentColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kPrimaryColor, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kPrimaryColor,
            side: const BorderSide(color: kPrimaryColor),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
        ),
      ),
      // Use named routes for navigation
      initialRoute: AppRoutes.loginRoute,
      routes: AppRoutes.routes,
      // Check if user is logged in and redirect accordingly
      home: Consumer<AuthService>(builder: (context, authService, _) {
        return authService.isLoggedIn
            ? const DashboardScreen()
            : const LoginScreen();
      }),
    );
  }
}
