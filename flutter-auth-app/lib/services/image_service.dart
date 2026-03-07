import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageService {

  Future<List<dynamic>> fetchImages(int page) async {

    try {
      final response = await http.get(
        Uri.parse("https://picsum.photos/v2/list?page=$page&limit=10")
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        // No more images available
        return [];
      } else {
        throw Exception("Server returned status code: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("No internet connection");
    } on TimeoutException {
      throw Exception("Request timed out");
    } on FormatException {
      throw Exception("Invalid response format");
    } catch (e) {
      throw Exception("Failed to load images: $e");
    }
  }

}