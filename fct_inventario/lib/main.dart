import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'gestion_productos.dart';  // Inventario


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  
  // Inicializar Firebase Cloud Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Solicitar permisos para recibir notificaciones
  NotificationSettings settings = await messaging.requestPermission();
  print("Permisos de notificación: ${settings.authorizationStatus}");

  // Obtener el token de FCM
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Configurar notificaciones en primer plano
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Recibido mensaje en primer plano: ${message.notification?.title}, ${message.notification?.body}');
    // Puedes mostrar una notificación local aquí si lo deseas.
  });

  // Configurar la notificación cuando la app está en segundo plano o cerrada
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Abrir la app desde la notificación: ${message.notification?.title}');
    // Puedes navegar a una página específica aquí si lo deseas.
  });
}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienvenido a Formfire',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

// PÁGINA DE BIENVENIDA CON DOS BOTONES
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono principal con sombra
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.fireplace, size: 100, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 20),
              
              // Título con estilo
              Text(
                '¡Bienvenido a Formfire!',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 40),
              
              // Botón de registro con borde redondeado
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Borde redondeado
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 5, // Sombra sutil
                ),
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
              
              // Botón de inicio de sesión con borde redondeado
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Borde redondeado
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 5, // Sombra sutil
                ),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      //Botón de inicio flotante
      //floatingActionButton: Padding(
      //  padding: const EdgeInsets.all(16.0),
      //  child: FloatingActionButton(
      //    onPressed: () {
      //      Navigator.pushReplacement(
      //        context,
      //        MaterialPageRoute(builder: (context) => WelcomePage()),
      //      );
      //    },
      //    backgroundColor: Colors.blueAccent,
      //    child: Icon(Icons.home, color: Colors.white),
      //    tooltip: 'Volver a la página principal',
      //  ),
      //),
    );
  }
}


// PÁGINA DE REGISTRO
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Registro'),
        backgroundColor: Colors.blueAccent, // Color de fondo de la AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Contenedor de formulario con sombra y bordes redondeados
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: MyForm(),
              ),
              SizedBox(height: 20),

              // Enlace a la página de inicio de sesión
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Tiene cuenta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Inicie sesión'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.home, color: Colors.white),
          tooltip: 'Volver a la página principal',
        ),
      ),
    );
  }
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

  Future<void> _saveData() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) return;

    // Guardar los datos en Firestore
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
      'password': password, // No se recomienda guardar contraseñas en texto plano en Firestore
      'createdAt': Timestamp.now(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos guardados correctamente')),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeAccountPage(name: name)),
    );

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
          // Campo para nombre
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu nombre';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Campo para email
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu email';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Campo para contraseña
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu contraseña';
              }
              return null;
            },
          ),
          SizedBox(height: 20),

          // Botón de enviar
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveData();
              }
            },
            child: Text('Enviar'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    // Consultar Firestore para verificar los datos de inicio de sesión
    final user = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).where('password', isEqualTo: password).get();

    if (user.docs.isNotEmpty) {
      final name = user.docs.first['name'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeAccountPage(name: name)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Credenciales incorrectas')));
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
    appBar: AppBar(
      title: Text('Iniciar sesión'),
      backgroundColor: Colors.blueAccent,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Iniciar sesión'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Enlace a la página de registro FUERA del contenedor
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿No tiene cuenta?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text('Regístrese'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomePage()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.home, color: Colors.white),
        tooltip: 'Volver a la página principal',
      ),
    ),
  );
}
}


// PÁGINA DE BIENVENIDA AL USUARIO REGISTRADO
class WelcomeAccountPage extends StatelessWidget {
  final String name;

  const WelcomeAccountPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo suave
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco para el marco
              border: Border.all(color: Colors.blueAccent, width: 2),
              borderRadius: BorderRadius.circular(12), // Bordes redondeados
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono dentro del marco
                Icon(
                  Icons.account_circle,
                  size: 120,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 24),
                // Texto de bienvenida dentro del marco
                Text(
                  '¡Hola, $name!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 30),
                // Botón de gestión de productos
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaginaGestionProductos()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    child: Text(
                      'Inventario',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                SizedBox(height: 40),
                // Botón de cerrar sesión
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    child: Text(
                      'Cerrar sesión',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}