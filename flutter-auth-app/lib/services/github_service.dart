import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_user.dart';

class GithubService {

  Future<GithubUser> fetchUser(String username) async {

    final response = await http.get(
      Uri.parse("https://api.github.com/users/$username"),
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

      return GithubUser.fromJson(data);

    } else if (response.statusCode == 404) {
      throw Exception("GitHub user '@$username' not found. Please check the username.");
    } else {
      throw Exception("Failed to load GitHub profile. Please try again.");
    }
  }
}