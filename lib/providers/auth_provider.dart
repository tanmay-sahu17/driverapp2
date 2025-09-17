import 'package:flutter/foundation.dart';
// Temporarily comment out Firebase imports for development
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  // Dummy user for development without Firebase
  bool _isSignedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _userDisplayName;

  /// Getters
  // User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _isSignedIn;

  /// Mock user object
  dynamic get user => _isSignedIn ? {'displayName': _userDisplayName, 'email': 'test@example.com', 'uid': 'mock_uid'} : null;

  /// Initialize auth provider
  AuthProvider() {
    initializeAuth();
  }

  void initializeAuth() {
    // Simulate auto-login for development
    Future.delayed(Duration(milliseconds: 500), () {
      _isSignedIn = false; // Start with signed out state
      notifyListeners();
    });
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Sign in method (mock)
  Future<void> signIn(String email, String password) async {
    _clearError();
    _setLoading(true);

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    try {
      // Mock sign in - any email/password works for development
      if (email.isNotEmpty && password.isNotEmpty) {
        _isSignedIn = true;
        _userDisplayName = email.split('@')[0]; // Use part before @ as display name
        _setLoading(false);
        notifyListeners();
      } else {
        throw Exception('Email and password cannot be empty');
      }
    } catch (e) {
      _setError('Sign in failed: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Sign up method (mock)
  Future<void> signUp(String email, String password) async {
    _clearError();
    _setLoading(true);

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    try {
      // Mock sign up - any email/password works for development
      if (email.isNotEmpty && password.isNotEmpty) {
        _isSignedIn = true;
        _userDisplayName = email.split('@')[0];
        _setLoading(false);
        notifyListeners();
      } else {
        throw Exception('Email and password cannot be empty');
      }
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Sign out method (mock)
  Future<void> signOut() async {
    _clearError();
    _setLoading(true);

    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    _isSignedIn = false;
    _userDisplayName = null;
    _setLoading(false);
    notifyListeners();
  }
}