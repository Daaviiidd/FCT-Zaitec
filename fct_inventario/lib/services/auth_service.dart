import '../repository/auth_repository.dart';

class AuthService {
  final AuthRepository authRepository;

  AuthService({required this.authRepository});

  Future<Map<String, dynamic>> login(String email, String password) {
    return authRepository.login(email, password);
  }
}