import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import '../login/login_page.dart';
import '../register/register_page.dart';

// PÁGINA DE BIENVENIDA CON LOADING AL INICIO
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/bitmap100.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                '¡Bienvenido a Oposiciones!',
                textAlign: TextAlign.center, // Centra el texto
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Registro'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Inicio de sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WIDGET DE LOADING PERSONALIZADO
class MiWidgetConLoadingPersonalizado extends StatelessWidget {
  const MiWidgetConLoadingPersonalizado({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
