import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://api.escuelajs.co/api/v1/auth/login";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email.trim(),
        "password": password.trim(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return {
        "success": true,
        "access_token": data["access_token"],
        "refresh_token": data["refresh_token"],
      };
    } else if (response.statusCode == 401) {
      return {
        "success": false,
        "message": "Invalid email or password",
      };
    } else {
      return {
        "success": false,
        "message": "Unexpected error occurred",
      };
    }
  }
}
