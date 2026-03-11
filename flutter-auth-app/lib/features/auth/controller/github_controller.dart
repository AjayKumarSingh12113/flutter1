import 'package:flutter/material.dart';
import '../../../models/github_user.dart';
import '../../../services/github_service.dart';

class GithubController extends ChangeNotifier {

  GithubUser? user;
  bool isLoading = false;
  String? _lastUsername;
  String? _errorMessage;

  final GithubService _service = GithubService();

  String? get errorMessage => _errorMessage;

  Future<void> getUser(String username) async {

    debugPrint('🔵 [GithubController] getUser() called for username: $username');

    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint('🟢 [GithubController] Starting GitHub API call for @$username');

    try {
      user = await _service.fetchUser(username);
      _lastUsername = username;
      _errorMessage = null;
      debugPrint('✅ [GithubController] GitHub API call successful - User: ${user?.name}');
    } catch (e) {
      user = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('❌ [GithubController] GitHub API call failed: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}