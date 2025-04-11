import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl;

  AuthRepository({required this.baseUrl});

  // Método de login que se comunica con el backend
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'success': true,
          'name': data['name'],
          'role': data['role'],
          'message': 'Inicio de sesión exitoso',
        };
      } else {
        return {
          'success': false,
          'message': 'Credenciales incorrectas o error en el servidor',
          'name': null,
          'role': null,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'name': null,
        'role': null,
      };
    }
  }
}
