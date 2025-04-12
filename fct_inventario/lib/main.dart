import 'package:fct_inventario/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart'; //Base de datos en tiempo real de Firebase
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'repository/auth_repository.dart';
import 'services/auth_service.dart';
import 'providers/carrito_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepository(baseUrl: '')),
        ProxyProvider<AuthRepository, AuthService>(
          update: (_, authRepository, __) => AuthService(authRepository: authRepository),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService: AuthService(authRepository: AuthRepository(baseUrl: ''))),
        ),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),//Añade al carrito
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OPO',
        home: LoginPage(),
      ),
    );
  }
}
