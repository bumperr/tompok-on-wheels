import 'package:flutter/material.dart';

// Colors
const kPrimaryColor =
    Color(0xFFE07E3D); // Same as customer app for brand consistency
const kAccentColor = Color(0xFF4682B4); // Steel blue for accent
const kBackgroundColor = Color(0xFFF7F9FB); // Light background color
const kCardColor = Colors.white;
const kTextColor = Color(0xFF3C4046);
const kSecondaryTextColor = Color(0xFF7C8396);

// Dashboard card colors
const kBookingCardColor = Color(0xFF4CAF50);
const kPetCardColor = Color(0xFF2196F3);
const kRevenueCardColor = Color(0xFFFF9800);
const kCustomerCardColor = Color(0xFF9C27B0);

// Status colors
const kPendingColor = Color(0xFFFF9800);
const kConfirmedColor = Color(0xFF4CAF50);
const kCancelledColor = Color(0xFFE53935);
const kInProgressColor = Color(0xFF2196F3);
const kCompletedColor = Color(0xFF4CAF50);

// Padding and Spacing
const kDefaultPadding = 16.0;
const kSmallPadding = 8.0;
const kLargePadding = 24.0;

// Text Styles
const kHeadingTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

const kSubheadingTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: kTextColor,
);

const kBodyTextStyle = TextStyle(
  fontSize: 16,
  color: kTextColor,
);

const kCaptionTextStyle = TextStyle(
  fontSize: 14,
  color: kSecondaryTextColor,
);

// Duration Constants
const kAnimationDuration = Duration(milliseconds: 300);

// Business Hours Defaults
const kDefaultOpeningTime = TimeOfDay(hour: 9, minute: 0);
const kDefaultClosingTime = TimeOfDay(hour: 17, minute: 0);

// Dashboard constants
const kDashboardCardHeight = 140.0;
const kDashboardCardWidth = 280.0;

// Service category types
const List<String> kServiceCategories = [
  'Grooming',
  'Veterinary',
  'Boarding',
  'Training',
  'Other'
];

// Image Assets
const String kLogoAsset = 'assets/images/logo.png';
const String kProviderPlaceholderAsset =
    'assets/images/provider_placeholder.png';

// API endpoints (to be replaced with real endpoints)
const String kBaseUrl = 'https://api.towprovider.com/api';
