import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class AuthService {
  static const String _baseUrl = authBaseUrl;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$_baseUrl/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String token = data['token'];
      // Save JWT token to SharedPreferences for future use
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwtToken', token);
      return data;
    } else {
      throw Exception(data);
    }
  }

  Future<Map<String, dynamic>> verifyEmail(String email, int otp) async {
    final url = Uri.parse("$_baseUrl/verify");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );
    return jsonDecode(response.body);

  }

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String password, String gender, String typeOfUser) async {
    final url = Uri.parse("$_baseUrl/register");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'gender': gender,
        'typeOfUser': typeOfUser,
      }),
    );

    return jsonDecode(response.body);

  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
  }
}