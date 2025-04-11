import 'package:fct_inventario/pages/register/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:flutter/material.dart';
import '../../pages/inventario/gestion_productos.dart';
import '../../pages/tienda/tienda_virtual_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore
import 'widgets/loading_widget.dart';


// PÁGINA DE INICIO DE SESIÓN
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //Formulario
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) return;

  try {
    // Intentar iniciar sesión con Firebase Authentication
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null && user.emailVerified) {
      // Verificar el rol desde Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        final userRole = userData?['role'];
        final userName = userData?['name'] ?? 'Usuario'; // Nombre o por defecto

        // Mostrar mensaje de bienvenida con el nombre
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Bienvenido, $userName!')),
        );

        // Redirigir según el rol del usuario
        if (userRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PaginaGestionProductos(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductGallery(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener los datos del usuario')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, verifica tu correo')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al iniciar sesión: $e')),
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

  // Página de Loading
  bool _isLoading = true;
   @override
  void initState() {
    super.initState();
    _inicializarApp();
  }

  Future<void> _inicializarApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Simula carga
    setState(() {
      _isLoading = false;
    });
  }
 @override
Widget build(BuildContext context) {
  if (_isLoading) {
    return const MiWidgetConLoadingPersonalizado();
  }

  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0), // Mucho espacio alrededor
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/images/bitmap100.png', height: 100),
            const SizedBox(height: 40),
            // Contenedor centrado con tamaño limitado
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Máximo ancho
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Iniciar sesión'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Texto de registro fuera del formulario
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿No tiene cuenta?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                  },
                  child: const Text('Regístrese'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

}
