import 'package:flutter/material.dart';
import '../../../models/github_user.dart';
import '../../../services/github_service.dart';

class GithubController extends ChangeNotifier {

  GithubUser? user;
  bool isLoading = false;
  String? _lastUsername;

  final GithubService _service = GithubService();

  Future<void> getUser(String username) async {

    debugPrint('🔵 [GithubController] getUser() called for username: $username');

    if (user != null && _lastUsername == username) {
      debugPrint('🟡 [GithubController] User already loaded, skipping API call');
      return;
    }

    isLoading = true;
    notifyListeners();

    debugPrint('🟢 [GithubController] Starting GitHub API call');

    try {
      user = await _service.fetchUser(username);
      _lastUsername = username;
      debugPrint('✅ [GithubController] GitHub API call successful - User: ${user?.name}');
    } catch (e) {
      debugPrint('❌ [GithubController] GitHub API call failed: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}