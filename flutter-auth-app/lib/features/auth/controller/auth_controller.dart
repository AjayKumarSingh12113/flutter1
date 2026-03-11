import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../services/google_auth_service.dart';
import '../../../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _currentUser != null;

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Register user
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.register(
        name: name,
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = result['message'] ?? 'Registration failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        _token = result['token'];
        _currentUser = result['user'];
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = result['message'] ?? 'Login failed';
        _token = null;
        _currentUser = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      _token = null;
      _currentUser = null;
      notifyListeners();
      return false;
    }
  }

  // Login with Google
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Sign in with Google using Firebase
      final googleResult = await GoogleAuthService.signInWithGoogle();

      if (!googleResult.success) {
        _isLoading = false;
        _errorMessage = googleResult.errorMessage ?? 'Google sign-in failed';
        notifyListeners();
        return false;
      }

      // Step 2: Send user data to backend API
      final result = await ApiService.googleLogin(
        email: googleResult.email ?? '',
        name: googleResult.name ?? 'Google User',
        photoUrl: googleResult.photoUrl,
      );

      if (result['success'] == true) {
        // Step 3: Store token and user data
        _token = result['token'];
        _currentUser = result['user'];

        // Step 4: Store token in local storage (SharedPreferences)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token ?? '');

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = result['message'] ?? 'Backend authentication failed';
        _token = null;
        _currentUser = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      _token = null;
      _currentUser = null;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  void logout() {
    _token = null;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
