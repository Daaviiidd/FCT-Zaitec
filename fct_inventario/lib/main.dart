import 'package:fct_inventario/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart'; //Base de datos en tiempo real de Firebase
import 'package:flutter/material.dart';
import 'firebase_options.dart';
//import 'pages/bienvenida/bienvenida_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Opo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

