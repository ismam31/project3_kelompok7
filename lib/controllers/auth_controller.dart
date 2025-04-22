import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthController {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // Ganti sesuai IP backend lo

  Future<bool> login(String username, String password, BuildContext context) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Simpan token atau data user kalau perlu
        print('Login sukses: ${data['token']}');
        return true;
      } else {
        var data = jsonDecode(response.body);
        _showErrorDialog(context, data['message'] ?? 'Login gagal');
        return false;
      }
    } catch (e) {
      _showErrorDialog(context, 'Terjadi kesalahan jaringan');
      return false;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
