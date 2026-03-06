import 'package:flutter/material.dart';
import '../../../models/github_user.dart';
import '../../../services/github_service.dart';

class GithubController extends ChangeNotifier {

  GithubUser? user;
  bool isLoading = false;

  final GithubService _service = GithubService();

  Future<void> getUser(String username) async {

    isLoading = true;
    notifyListeners();

    user = await _service.fetchUser(username);

    isLoading = false;
    notifyListeners();
  }
}