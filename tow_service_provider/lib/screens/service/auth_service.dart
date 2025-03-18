import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? providerId;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.providerId,
  });

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'providerId': providerId,
    };
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      providerId: json['providerId'],
    );
  }
}

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  String? _token;
  bool _isInitialized = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoggedIn => _currentUser != null && _token != null;
  bool get isInitialized => _isInitialized;

  // Initialize auth state
  Future<void> initializeAuth() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      final savedToken = prefs.getString('token');

      if (userJson != null && savedToken != null) {
        _currentUser = UserModel.fromJson(json.decode(userJson));
        _token = savedToken;
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing auth: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Login function
  Future<bool> login(String email, String password) async {
    // In a real app, this would make an API call to authenticate
    // For demo purposes, we'll use a mock implementation

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock authentication - In a real app, validate credentials with backend
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Mock user data that would come from backend
        final userData = {
          'uid': 'provider-123',
          'email': email,
          'displayName': 'Pet Care Provider',
          'photoURL': null,
          'providerId': 'sp001',
        };

        // Create user model and token
        _currentUser = UserModel.fromJson(userData);
        _token = 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(userData));
        await prefs.setString('token', _token!);

        notifyListeners();
        return true;
      } catch (e) {
        print('Login error: $e');
        return false;
      }
    }

    return false;
  }

  // Register function
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
    required String businessName,
    required String businessCategory,
  }) async {
    // In a real app, this would make an API call to register a new service provider
    // For demo purposes, we'll use a mock implementation

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Mock user data that would come from backend after registration
      final userData = {
        'uid': 'provider-${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'displayName': displayName,
        'photoURL': null,
        'providerId': 'sp${DateTime.now().millisecondsSinceEpoch % 1000}',
      };

      // Create user model and token
      _currentUser = UserModel.fromJson(userData);
      _token = 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(userData));
      await prefs.setString('token', _token!);

      notifyListeners();
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      _currentUser = null;
      _token = null;

      // Clear from local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('token');

      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      if (_currentUser == null) return false;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create updated user data
      final updatedUserData = {
        'uid': _currentUser!.uid,
        'email': _currentUser!.email,
        'displayName': displayName ?? _currentUser!.displayName,
        'photoURL': photoURL ?? _currentUser!.photoURL,
        'providerId': _currentUser!.providerId,
      };

      // Update current user
      _currentUser = UserModel.fromJson(updatedUserData);

      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(updatedUserData));

      notifyListeners();
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // Helper function to authenticate HTTP requests
  Map<String, String> getAuthHeaders() {
    if (_token == null) return {};

    return {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    };
  }
}
