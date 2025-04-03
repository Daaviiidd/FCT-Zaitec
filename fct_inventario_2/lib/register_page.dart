import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tienda_virtual.dart'; // Asegúrate de importar la página correcta para redirigir

// PÁGINA DE REGISTRO
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario de Registro')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const MyForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// FUNCIONES DE VALIDACIÓN DE CONTRASEÑA
bool isValidPassword(String password) {
  // Contraseña mínima de 6 caracteres y debe contener al menos un número
  final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
  return passwordRegExp.hasMatch(password);
}

// FORMULARIO DE REGISTRO
class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  MyFormState createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // FUNCION PARA REGISTRAR AL USUARIO
  Future<void> _registerUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validación básica de los campos
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return;
    }

    // Verificación de la contraseña
    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La contraseña debe tener al menos 6 caracteres y un número',
          ),
        ),
      );
      return;
    }

    try {
      // Crear un nuevo usuario con Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Enviar correo de verificación
      User? user = userCredential.user;
      await user?.sendEmailVerification();

      // Guardar datos del usuario en Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'email': email,
        'role': 'user', // Rol de usuario por defecto
        'createdAt': Timestamp.now(),
      });

      // Mostrar mensaje de éxito, indicando que debe verificar su correo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registro exitoso. Se ha enviado un correo de verificación.',
          ),
        ),
      );

      // Esperar que el correo sea verificado antes de permitir el acceso
      // Esto simula que esperamos que el usuario haya verificado su correo
      while (!user.emailVerified) {
        await Future.delayed(const Duration(seconds: 1));
        await user
            .reload(); // Recargar el estado del usuario para ver si ha verificado el correo
      }

      // Redirigir al usuario a la página de la tienda virtual o cualquier página que desees
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductGallery()),
      );
    } catch (e) {
      // Mostrar mensaje de error si ocurre un problema
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }

    // Limpiar los campos del formulario
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Campo para el nombre
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu nombre';
              }
              return null;
            },
          ),
          // Campo para el correo electrónico
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu email';
              }
              return null;
            },
          ),
          // Campo para la contraseña
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu contraseña';
              }
              if (!isValidPassword(value)) {
                return 'La contraseña debe tener al menos 6 caracteres y un número';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Botón de registro
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _registerUser(); // Usamos esta función para registrar al usuario
              }
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }
}
