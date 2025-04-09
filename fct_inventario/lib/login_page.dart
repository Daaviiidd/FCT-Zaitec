import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'gestion_productos.dart';
import 'tienda_virtual.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print('📨 Intentando iniciar sesión con:');
    print('📧 Email: $email');
    print('🔑 Contraseña: $password');

    if (email.isEmpty || password.isEmpty) {
      print('⚠️ Email o contraseña vacíos');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userRole = userDoc['role'];
        final userName = userDoc['name'];

        print('✅ Inicio de sesión exitoso');
        print('🧑‍💼 Rol: $userRole');
        print('🙋‍♂️ Nombre: $userName');

        if (userRole == 'admin') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bienvenido, Administrador $userName')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaginaGestionProductos()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bienvenido, $userName')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductGallery()),
          );
        }
      } else {
        print('❌ No se encontró ningún usuario con esas credenciales');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    } catch (e) {
      print('🔥 Error durante el inicio de sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
    }

    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
