import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  AuthProvider({required this.authService});

  Future<Map<String, dynamic>> login(String email, String password) {
    return authService.login(email, password);
  }
  
}
