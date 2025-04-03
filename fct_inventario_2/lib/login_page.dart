import 'package:cloud_firestore/cloud_firestore.dart'; // Base de datos en tiempo real de Firebase
import 'package:flutter/material.dart';
import 'gestion_productos.dart';
import 'tienda_virtual.dart';

// PÁGINA DE INICIO DE SESIÓN
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

    print("Intentando iniciar sesión con: $email");

    if (email.isEmpty || password.isEmpty) {
      print("Error: Campos vacíos");
      return;
    }

    try {
      // Consultar Firestore para verificar los datos de inicio de sesión
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password) // ⚠️ No recomendado (usar Firebase Auth)
          .get();

      print("Usuarios encontrados: ${userSnapshot.docs.length}");

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final userRole = userDoc['role']; // Obtener el rol del usuario

        print("Rol del usuario: $userRole");

        // Redirigir según el rol del usuario
        if (userRole == 'admin') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bienvenido, Administrador')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaginaGestionProductos()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bienvenido, Usuario')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductGallery()),
          );
        }
      } else {
        print("Credenciales incorrectas");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    } catch (e) {
      print("Error en la consulta a Firestore: $e");
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

  // Formulario de inicio de sesión
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
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
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
