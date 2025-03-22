import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing Page',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(), // Ruta para la landing page
        '/login': (context) => LoginPage(), // Ruta para el formulario de inicio de sesión
        '/register': (context) => RegisterPage(), // Ruta para el formulario de registro
      },
    );
  }
}

// Landing Page
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¡Bienvenido a nuestra plataforma!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Por favor, inicia sesión para continuar.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navega al formulario de inicio de sesión
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

// Formulario de inicio de sesión
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: SizedBox.shrink()), // Elimina el título
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra todo verticalmente
          children: [
            // Texto centrado arriba del formulario
            Text(
              'Inicio de sesión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Centra el texto
            ),
            SizedBox(height: 20), // Espacio entre el texto y el formulario
            Container(
              padding: EdgeInsets.all(16), // Espaciado interno
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                border: Border.all(
                  color: Colors.blue, // Color del borde
                  width: 2, // Grosor del borde
                ),
              ),
              child: MyForm(),
            ),
            SizedBox(height: 20), // Espacio entre el formulario y los enlaces
            // Texto de "¿No tiene una cuenta?" con enlace "Regístrese"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¿No tiene una cuenta? '),
                TextButton(
                  onPressed: () {
                    // Navegar al formulario de registro
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Regístrese',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espacio entre los enlaces y el formulario
            // Fila con los enlaces
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los enlaces
              children: [
                TextButton(
                  onPressed: () {
                    // Acción para las condiciones de uso
                    print("Condiciones de uso");
                  },
                  child: Text(
                    'Condiciones de uso',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Text('|', style: TextStyle(color: Colors.black)),
                TextButton(
                  onPressed: () {
                    // Acción para la política de privacidad
                    print("Política de privacidad");
                  },
                  child: Text(
                    'Política de privacidad',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Formulario de registro
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario de registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra todo verticalmente
          children: [
            // Texto centrado arriba del formulario
            Text(
              'Formulario de registro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Centra el texto
            ),
            SizedBox(height: 20), // Espacio entre el texto y el formulario
            Container(
              padding: EdgeInsets.all(16), // Espaciado interno
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
                border: Border.all(
                  color: Colors.blue, // Color del borde
                  width: 2, // Grosor del borde
                ),
              ),
              child: MyForm(),
            ),
            SizedBox(height: 20), // Espacio entre el formulario y los enlaces
            // Fila con los enlaces
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los enlaces
              children: [
                TextButton(
                  onPressed: () {
                    // Acción para las condiciones de uso
                    print("Condiciones de uso");
                  },
                  child: Text(
                    'Condiciones de uso',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Text('|', style: TextStyle(color: Colors.black)),
                TextButton(
                  onPressed: () {
                    // Acción para la política de privacidad
                    print("Política de privacidad");
                  },
                  child: Text(
                    'Política de privacidad',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu nombre';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Introduce un email válido';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text('Estos son sus datos:\nNombre: $_name\nEmail: $_email'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Color azul
            ),
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
