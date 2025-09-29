import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vigilancia_app/firebase_options.dart';
import 'package:vigilancia_app/screens/auth/login_screen.dart';
import 'package:vigilancia_app/screens/home/home_screen.dart';
import 'package:vigilancia_app/screens/relatorios/pendencias_screen.dart';
import 'package:vigilancia_app/services/auth_service.dart';
import 'package:vigilancia_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VigilanciaApp());
}

class VigilanciaApp extends StatelessWidget {
  const VigilanciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigilância App',
      theme: AppTheme.darkTheme,
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/pendencias': (context) => const PendenciasScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
