import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  static const String baseUrl =
      'https://api.bloodlife.org/api'; // Replace with your API base URL

  /// Get the token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Replace 'token' with your token key
  }

  /// Send a GET request
  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final url = Uri.parse('$baseUrl$endpoint');
    return http.get(url, headers: headers);
  }

  /// Send a POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl$endpoint');
    return http.post(url, headers: headers, body: jsonEncode(body));
  }

  /// Send a PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl$endpoint');
    return http.put(url, headers: headers, body: jsonEncode(body));
  }

  /// Send a DELETE request
  Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl$endpoint');
    return http.delete(url, headers: headers);
  }
}
