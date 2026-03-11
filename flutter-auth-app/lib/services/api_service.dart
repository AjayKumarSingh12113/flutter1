import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class ApiService {
  // API base URL - platform aware
  // static String get baseUrl {
  //   if (kIsWeb) {
  //     // For web (Chrome, Firefox, etc.) - use localhost
  //     return 'http://localhost:5000/api';
  //   } else {
  //     // For Android emulator - use 10.0.2.2
  //     // return 'http://10.0.2.2:5000/api';
  //      return 'http://192.168.1.35:5000/api';
  //   }
  // }
  static String get baseUrl {
    if (kIsWeb) {
      // Web browser
      return 'http://localhost:5000/api';
    } else if (Platform.isAndroid) {
      // Android device / emulator
      const bool isEmulator =
          bool.fromEnvironment('FLUTTER_EMULATOR', defaultValue: false);

      if (isEmulator) {
        return 'http://10.0.2.2:5000/api'; // emulator
      } else {
        return 'http://192.168.1.35:5000/api'; // real phone
      }
    } else {
      // fallback
      return 'http://localhost:5000/api';
    }
  }

  // Register API call
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException(
                'Register request timed out. Check if backend server is running.'),
          );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Registration successful',
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message':
              jsonDecode(response.body)['message'] ?? 'Registration failed',
          'data': null,
        };
      }
    } on TimeoutException catch (e) {
      return {
        'success': false,
        'message': 'Connection timeout: ${e.message}',
        'data': null,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: Check backend server is running on port 5000',
        'data': null,
      };
    }
  }

  // Login API call
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException(
                'Login request timed out. Check if backend server is running.'),
          );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Login successful',
          'token': responseData['token'],
          'user': User.fromJson(responseData['user']),
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Login failed',
          'token': null,
          'user': null,
        };
      }
    } on TimeoutException catch (e) {
      return {
        'success': false,
        'message': 'Connection timeout: ${e.message}',
        'token': null,
        'user': null,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: Check backend server is running on port 5000',
        'token': null,
        'user': null,
      };
    }
  }

  // Google Login API call
  static Future<Map<String, dynamic>> googleLogin({
    required String email,
    required String name,
    required String? photoUrl,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/google-login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'name': name,
              'photo': photoUrl,
            }),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException(
                'Google login request timed out. Check if backend server is running.'),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Google login successful',
          'token': responseData['token'],
          'user': User.fromJson(responseData['user']),
        };
      } else {
        return {
          'success': false,
          'message':
              jsonDecode(response.body)['message'] ?? 'Google login failed',
          'token': null,
          'user': null,
        };
      }
    } on TimeoutException catch (e) {
      return {
        'success': false,
        'message': 'Connection timeout: ${e.message}',
        'token': null,
        'user': null,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: Check backend server is running on port 5000',
        'token': null,
        'user': null,
      };
    }
  }
}
