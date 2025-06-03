import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://192.168.1.22:8000/api';

  static Future<String?> loginWithGoogleToBackend(
    String email,
    String name,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login-google'),
        body: {'email': email, 'name': name},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'];
      } else {
        print('Error Backend Login: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error API Login: $e');
      return null;
    }
  }
}
